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
    @IBOutlet weak var networkStatusView: CitieListHeaderView!
    
    var container: NSPersistentContainer = CoreDataStack.shared.persistentContainer
    var weathersCacheDict: [String: ParsedWeather] = [:]
    var fetchedResultsController: NSFetchedResultsController<City>!
    
    private let locationManager = LocationManager()
    var userLocationPlacemark: CLPlacemark?
    var userPlacemarkWeather: ParsedWeather?
    
    // MARK: - VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup TableView Header
        self.tableView.sectionHeaderTopPadding = 0
        self.networkStatusView.frame.size.height = 0
        
        // Setup VC title
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Weather"
        
        self.startLocationUpdates()
                
        NetworkMonitor.shared.startMonitoring()
        NetworkMonitor.shared.onNetworkStatusChange = { [weak self] (status) in
            guard let sSelf = self else { return }
            
            if status == .satisfied {
                DispatchQueue.main.async {
                    sSelf.networkStatusView.showNetworkStatus(needToShow: false) {
                        sSelf.showNetworkStatusView(0)
                        sSelf.tableView.reloadData()
                    }
                }
            } else if status == .unsatisfied {
                DispatchQueue.main.async {
                    if let date = NetworkMonitor.shared.lastOnlineTime {
                        sSelf.networkStatusView.dateLabel.text = "Last online: " + date.formatLocalTime(format: "h:mm a")
                    }
                    
                    sSelf.networkStatusView.showNetworkStatus(needToShow: true) {
                        sSelf.showNetworkStatusView(44)
                    }
                }
            }
        }
        
        // Setup Core Data
        guard container != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        setupFetchedResultController()
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
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
    
    fileprivate func setupSearchController() {
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
    
    /// Getting  the weather forecast for a city.
    /// - Parameter city: Stored city .
    /// - Parameter latitude: Latitude of a city location.
    /// - Parameter longitude: Longitude of a city location.
    /// - Parameter completionBlock: A closure to call when the weather forecast has been got.
    /// - Parameter errorBlock: A closure to call when error occured.
    
    func getWeatherForCity(_ city: City,
                           latitude: Double,
                           longitude: Double,
                           completionBlock: @escaping (_ weather: ParsedWeather, _ city: City) -> Void,
                           errorBlock: @escaping (_ city: City) -> Void) {
        if needToReload(city.placemarkTitle ?? "") {
            WeatherDataCenter.shared.getWeatherForLocation(location: CLLocation(latitude: latitude, longitude: longitude)) { result in
                switch result {
                case .success(let weather): 
                    if let key = city.placemarkTitle {
                        self.weathersCacheDict[key] = weather
                        completionBlock(weather, city)
                    }
                case .failure(let error): 
                    print(error)
                    errorBlock(city)
                }
            }
        } else if let cache = self.weathersCacheDict[city.placemarkTitle ?? ""] {
            completionBlock(cache, city)
        } else {
            errorBlock(city)
        }
    }
    
    /// Getting  the weather forecast for a city placemark of current user location.
    /// - Parameter locationPlacemark: A city placemark of current user location.
    /// - Parameter completionBlock: A closure to call when the weather forecast has been got.
    /// - Parameter errorBlock: A closure to call when error occured.
    
    func getWeatherForPlacemark(_ locationPlacemark: MKPlacemark,
                                completionBlock: @escaping (_ weather: ParsedWeather, _ placemark: MKPlacemark) -> Void,
                                errorBlock: @escaping (_ placemark: MKPlacemark) -> Void) {
        if needToReload(locationPlacemark.title ?? "") {
            WeatherDataCenter.shared.getWeatherForLocation(location: CLLocation(latitude: locationPlacemark.coordinate.latitude, longitude: locationPlacemark.coordinate.longitude)) { result in
                switch result {
                case .success(let weather):
                    if let key = locationPlacemark.title {
                        self.weathersCacheDict[key] = weather
                        completionBlock(weather, locationPlacemark)
                    }
                case .failure(let error):
                    print(error)
                    errorBlock(locationPlacemark)
                }
            }
        } else if let cache = self.weathersCacheDict[locationPlacemark.title ?? ""] {
            completionBlock(cache, locationPlacemark)
        } else {
            errorBlock(locationPlacemark)
        }
    }
    
    /// Returns a Boolean value that indicates whether the city weather forecast need to reload .
    ///
    /// There is a dictionary where key is a placemark title for a city and value is the last date of getting weather forecast.
    /// If the difference between the last date of updating and current date more then 10 min, it means weather forecast needs ro be updated.
    ///
    /// - Parameter cityPlacemarkTitle: String with the placemark title for a city.
    /// - Returns: true if the city forecast should to be reloaded, otherwise false.
    
    private func needToReload(_ cityPlacemarkTitle: String) -> Bool {
        var wDate: Date?
        let nowDate = Date.now
        var diff = 0
        
        wDate = self.weathersCacheDict[cityPlacemarkTitle]?.currentWeather.date

        if let wDate = wDate {
            diff = Int(nowDate.timeIntervalSince1970 - wDate.timeIntervalSince1970)
        } else {
            return true
        }
        
        return diff > 600
    }
    
    /// Delete the city from CoreData
    /// - Parameter indexPath: Chosen indexPath for deleting city
    
    private func deleteCity(at indexPath: IndexPath) {
        let deleteIndexPath = IndexPath(row: indexPath.row, section: 0)
        let cityToDelete = fetchedResultsController.object(at: deleteIndexPath)
        CoreDataStack.shared.persistentContainer.viewContext.delete(cityToDelete)

        try? CoreDataStack.shared.persistentContainer.viewContext.save()
    }
    
    // MARK: - Network Status
    
    /// Show Network Status View
    /// - Parameter size: size of Network Status View
    
    func showNetworkStatusView(_ size: Double) {
        tableView.beginUpdates()
        self.networkStatusView.frame.size.height = size
        self.tableView.tableHeaderView = self.networkStatusView
        tableView.endUpdates()
    }
    
    // MARK: - User Location check
    
    func startLocationUpdates() {
        locationManager.startLocationManagerIfNeeded()
        locationManager.onLocationChange = {[weak self] (result) in
            guard let sSelf = self, let location = result else { return }
            
            location.placemark { placemark, error in
                guard let placemark = placemark else {
                    print("Error:", error ?? "nil")
                    return
                }
                
                // request weather info for placemark
                sSelf.getWeatherForPlacemark(MKPlacemark(placemark: placemark)) { weather, _ in
                    sSelf.userPlacemarkWeather = weather
                    sSelf.userLocationPlacemark = placemark
                    sSelf.tableView.reloadSections([Section.currentLocationWeather.rawValue], with: .none)
                } errorBlock: { placemark in
                    print("something went wrong \(placemark)")
                }
            }
        }
        
        // if user change Authorization Status need to reload tableview to hide my location cell
        locationManager.onAuthStatusChange = {[weak self] (_) in
            guard let sSelf = self else { return }
            
            sSelf.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    
    // openCityWeather
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? CityWeatherViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                if indexPath.section == Section.currentLocationWeather.rawValue {
                    guard let placemark = userLocationPlacemark else { return }
                    controller.city = (placemark.locality?.formattedPlacemarkTitle() ?? "", placemark.name ?? "", placemark.location?.coordinate.latitude ?? 0, placemark.location?.coordinate.longitude ?? 0, placemark.timeZone?.abbreviation() ?? "EST")
                } else {
                    let city = fetchedResultsController.object(at: IndexPath(row: indexPath.row, section: 0))
                    controller.city = (city.name ?? "", city.placemarkTitle ?? "", city.lat, city.long, city.timeZone ?? "EST")
                }
                controller.isTopButtonHidden = (cancel: true, add: true)
            }
        }
    }
}

// MARK: - Table View Extensions

extension CitiesListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension CitiesListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Section.currentLocationWeather.rawValue {
            if locationManager.locationStatus == .authorizedAlways || locationManager.locationStatus == .authorizedWhenInUse {
                return 1
            } else {
                return 0
            }
        } else {
            return fetchedResultsController.sections?[0].numberOfObjects ?? 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (fetchedResultsController.sections?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == Section.currentLocationWeather.rawValue {
            return 40
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Section.currentLocationWeather.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CitiesListTableViewCell", for: indexPath) as! CitiesListTableViewCell
            if let placemark = userLocationPlacemark, let weather = userPlacemarkWeather {
                cell.fillWeatherCell(cityName: placemark.locality?.formattedPlacemarkTitle() ?? "", cityTimeZone: placemark.timeZone?.identifier, weather: weather, isLocal: true)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CitiesListTableViewCell", for: indexPath) as! CitiesListTableViewCell
            let cellCity = fetchedResultsController.object(at: IndexPath(row: indexPath.row, section: 0))
            
            getWeatherForCity(cellCity, latitude: cellCity.lat, longitude: cellCity.long) { weather, city in
                cell.fillWeatherCell(cityName: city.name, cityTimeZone: city.timeZone, weather: weather)
            } errorBlock: { city in
                cell.fillWeatherCell(cityName: city.name, cityTimeZone: nil, weather: nil, isLocal: false)
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
