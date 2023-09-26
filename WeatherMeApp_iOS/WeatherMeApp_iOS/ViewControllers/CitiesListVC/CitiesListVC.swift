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

class CitiesListVC: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    var container: NSPersistentContainer = CoreDataStack.shared.persistentContainer
    var weathersDict: [String:Weather] = [:]
    var fetchedResultsController: NSFetchedResultsController<City>!
    
    // MARK: - VC Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    completionBlock: @escaping (_ weather: Weather, _ city: City) -> (),
                    errorBlock: @escaping (_ city: City) -> ()) {
                        
        if needToReload(city) {
            WeatherDataCenter.shared.getWeatherForLocation(location: CLLocation(latitude: city.lat, longitude: city.long)) { result in
                switch result {
                case .success(let weather) :
                    if let key = city.placemarkTitle {
                        self.weathersDict[key] = weather
                        completionBlock(weather, city)
                    }
                case .failure(let error) :
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
    
    //check if weather is need to update (not early then 10 min)
    func needToReload(_ city: City) -> Bool {
        var wDate: Date?
        let nowDate = Date.now
        var diff = 0
        
        if let key = city.placemarkTitle {
            wDate = self.weathersDict[key]?.currentWeather.date
        }
        if let wd = wDate {
            diff = Int(nowDate.timeIntervalSince1970 - wd.timeIntervalSince1970)
        } else {
            return true
        }
        
        return diff > 600
    }
    
    func deleteCity(at indexPath: IndexPath) {
        let cityToDelete = fetchedResultsController.object(at: indexPath)
        CoreDataStack.shared.persistentContainer.viewContext.delete(cityToDelete)

        try? CoreDataStack.shared.persistentContainer.viewContext.save()
    }
    
    // MARK: - Navigation
    // openCityWeather
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CityWeatherViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                let city = fetchedResultsController.object(at: indexPath)
                vc.city = (city.name ?? "", city.placemarkTitle ?? "", city.lat, city.long, city.timeZone ?? "EST")
                vc.isTopButtonHidden = (cancel: true, add: true)
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
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitiesListTableViewCell", for: indexPath) as! CitiesListTableViewCell
        let cellCity = fetchedResultsController.object(at: indexPath)
        
        getWeatherForCity(cellCity) { weather, city in
            cell.fillWeatherCell(with: city, and: weather)
        } errorBlock: { city in
            cell.timeLabel.text = "something went wrong"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") {  (_, _, completion) in
            self.deleteCity(at: indexPath)
            completion(true)
        }

        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
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
        print("didChange newIndexPath \(type)")
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
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


