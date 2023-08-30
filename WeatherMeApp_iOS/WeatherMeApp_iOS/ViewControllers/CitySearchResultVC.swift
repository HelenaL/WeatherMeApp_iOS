//
//  CitySearchResultVC.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 4/24/22.
//

import UIKit
import MapKit

class CitySearchResultVC: UITableViewController, CitySearchResultVCDelegate {
    
    // MARK: - Properties
            
    // Create a seach completer object
    var searchCompleter = MKLocalSearchCompleter()
    
    // These are the results that are returned from the searchCompleter & what we are displaying
    // on the searchResultsTable
    var searchResults = [MKLocalSearchCompletion]()
    
    // MARK: - VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell

        let item = searchResults[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = item.title
        content.secondaryText = item.subtitle
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
// MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "openNewCityWeather",
//            let nav = segue.destination as? UINavigationController,
//            let vc = nav.viewControllers.first as? CityWeatherViewController {
//            vc.cityNAme = "Set City Name"
//        }

        if let vc = segue.destination as? CityWeatherViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
               // vc.isTopButtonHidden = false
                
                let result = searchResults[indexPath.row]
                let searchRequest = MKLocalSearch.Request(completion: result)
                
                let search = MKLocalSearch(request: searchRequest)
                search.start { (response, error) in
                    guard let coordinate = response?.mapItems[0].placemark.coordinate else {
                         return
                    }

                    guard let name = response?.mapItems[0].name else {
                         return
                    }
                    
                    guard let placemarkTitle = response?.mapItems[0].placemark.title else {
                         return
                    }
                    
                    guard let timeZone = response?.mapItems[0].timeZone?.abbreviation() else {
                        return
                    }
                    
                    let lat = coordinate.latitude
                    let lon = coordinate.longitude

                    print("Selected City: \(name) \(placemarkTitle) \(lat) \(lon) \(timeZone)")
                    
                    vc.city = (name, placemarkTitle, lat, lon, timeZone)
                    vc.searchDelegate = self
                    
                    //check that the city exist in list of saved city, if exist need to hide add button
                    vc.isTopButtonHidden = (cancel: false, add: CoreDataStack.shared.isContainCity(placemarkTitle: placemarkTitle))
                
                }

            }
        }
    }
    
    
    
// MARK: - CitySearchResultVC Delegate implementation
    
    func dismissCitySearchResultVC() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Search Controller Extensions

extension CitySearchResultVC: UISearchControllerDelegate {
    
}

extension CitySearchResultVC: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        //searchCityByName(name: searchText)
//    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchCompleter.queryFragment = searchBar.text ?? " "
    }
}

extension CitySearchResultVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchCompleter.queryFragment = text
    }
}

extension CitySearchResultVC: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
}
