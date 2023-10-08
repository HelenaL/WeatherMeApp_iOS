//
//  CitiesListVC.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 4/12/22.
//

import UIKit
import MapKit
import CoreData
import WeatherKit
import CoreLocation

class CitiesListVC: UIViewController {
    
    enum Section: Int {
        case currentLocationWeather = 0
        case cityWeather
    }

    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    var container: NSPersistentContainer = CoreDataStack.shared.persistentContainer
    var weathersDict: [String: Weather] = [:]
    var fetchedResultsController: NSFetchedResultsController<City>!
    
    private let locationManager = LocationManager()
    var userLocation: UserLocationInfo?
    
    // MARK: - VC Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startLocationUpdates()
        
        // Setup VC title
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Weather"
        
        // Setup Core Data
        guard container != nil else {
           // return
            fatalError("This view needs a persistent container.")
        }
        
        setupFetchedResultController()
                
        // Setup Search Controller
        let resultsTableController =
                self.storyboard?.instantiateViewController(withIdentifier: "CitySearchResultVC") as? CitySearchResultVC
        resultsTableController?.searchBarDelegate = self
        
        let searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.delegate = resultsTableController
        searchController.searchResultsUpdater = resultsTableController
        searchController.searchBar.delegate = resultsTableController // Monitor when the search button is tapped.
        searchController.obscuresBackgroundDuringPresentation = true
        
        // Place the search bar in the navigation bar.
        navigationItem.searchController = searchController
            
        // Make the search bar always visible.
        navigationItem.hidesSearchBarWhenScrolling = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupFetchedResultController()

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    fileprivate func setupFetchedResultController() {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("the fetch couldn't perform \(error.localizedDescription)")
        }

        tableView.reloadData()
    }
        
    func getWeatherForCity(_ city: City,
                           completionBlock: @escaping (_ weather: Weather, _ city: City) -> Void,
                           errorBlock: @escaping (_ city: City) -> Void) {
        if needToReload(city) {
            WeatherDataCenter.shared.getWeatherForLocation(location: CLLocation(latitude: city.lat, longitude: city.long)) { result in
                switch result {
                case .success(let weather): 
                    if let key = city.placemarkTitle {
                        self.weathersDict[key] = weather
                        completionBlock(weather, city)
                    }
                case .failure(let error): 
                    print(error)
                    errorBlock(city)
                }
            }
        } else if let cache = self.weathersDict[city.placemarkTitle ?? ""] {
            completionBlock(cache, city)
        } else {
            errorBlock(city)
        }
    }
    
    // check if weather is need to update (not early then 10 min)
    func needToReload(_ city: City) -> Bool {
        var wDate: Date?
        let nowDate = Date.now
        var diff = 0
        
        if let key = city.placemarkTitle {
            wDate = self.weathersDict[key]?.currentWeather.date
        }
        if let wDate = wDate {
            diff = Int(nowDate.timeIntervalSince1970 - wDate.timeIntervalSince1970)
        } else {
            return true
        }
        
        return diff > 600
    }
    
    func deleteCity(at indexPath: IndexPath) {
        let deleteIndexPath = IndexPath(row: indexPath.row, section: 0)
        let cityToDelete = fetchedResultsController.object(at: deleteIndexPath)
        CoreDataStack.shared.persistentContainer.viewContext.delete(cityToDelete)

        try? CoreDataStack.shared.persistentContainer.viewContext.save()
    }
    
    // MARK: - User Location check
    
    func startLocationUpdates() {
        locationManager.startLocationManagerIfNeeded()
        locationManager.onLocationChange = {[weak self] (result) in
            guard let sSelf = self, let location = result else {
                return
            }
            
            print("LOCATION: \(location)")
            // request weather info
            // sSelf.networkingClient.getAllWeatherByUserLocationCoordinates(coordinates: location.coordinate, completion: sSelf.handleUserDataResponse)
            
        }
    }
    
    // MARK: - Navigation
    // openCityWeather
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? CityWeatherViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                let city = fetchedResultsController.object(at: IndexPath(row: indexPath.row, section: 0))
                controller.city = (city.name ?? "", city.placemarkTitle ?? "", city.lat, city.long, city.timeZone ?? "EST")
                controller.isTopButtonHidden = (cancel: true, add: true)
            }
        }
    }
}

// MARK: - Table View Extensions

extension CitiesListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row + 1)
    }
}

extension CitiesListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Section.currentLocationWeather.rawValue {
            return 0
        } else {
            return fetchedResultsController.sections?[0].numberOfObjects ?? 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (fetchedResultsController.sections?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Section.currentLocationWeather.rawValue {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "CitiesListTableViewCell", for: indexPath) as! CitiesListTableViewCell
////            let cellCity = fetchedResultsController.object(at: indexPath)
////            
////            getWeatherForCity(cellCity) { weather, city in
////                cell.fillWeatherCell(with: city, and: weather)
////            } errorBlock: { _ in
////                cell.timeLabel.text = "something went wrong"
////            }
            return UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CitiesListTableViewCell", for: indexPath) as! CitiesListTableViewCell
            let cellCity = fetchedResultsController.object(at: IndexPath(row: indexPath.row, section: 0))
            
            getWeatherForCity(cellCity) { weather, city in
                cell.fillWeatherCell(with: city, and: weather)
            } errorBlock: { _ in
                cell.timeLabel.text = "something went wrong"
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == Section.cityWeather.rawValue {
            let contextItem = UIContextualAction(style: .destructive, title: "Delete") {  (_, _, completion) in
                self.deleteCity(at: indexPath)
                completion(true)
            }

            let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

            return swipeActions
        }
        return nil
    }
}

// MARK: - Fetched Results Controller

extension CitiesListVC: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else {
                return
            }
            let insertIndexPath = IndexPath(row: newIndexPath.row, section: Section.cityWeather.rawValue)
            tableView.insertRows(at: [insertIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else {
                return
            }
            let deleteIndexPath = IndexPath(row: indexPath.row, section: Section.cityWeather.rawValue)
            tableView.deleteRows(at: [deleteIndexPath], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
}

// MARK: - CitySearchBar Delegate

extension CitiesListVC: CitySearchBarDelegate {
    func cleanSearchBar() {
        navigationItem.searchController?.searchBar.text = nil
    }
    
    func endEditingTableView() {
        tableView.isEditing = false
    }
}
