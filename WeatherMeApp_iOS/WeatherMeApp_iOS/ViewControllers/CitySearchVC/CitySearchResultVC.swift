//
//  CitySearchResultVC.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 4/24/22.
//

import UIKit
import MapKit

protocol CitySearchBarDelegate: AnyObject {
    func cleanSearchBar()
    func endEditingTableView()
}

class CitySearchResultVC: UITableViewController, CitySearchResultVCDelegate {
    
    // MARK: - Properties
    weak var searchBarDelegate: CitySearchBarDelegate?
    
    // Create a seach completer object
    var searchCompleter = MKLocalSearchCompleter()
    
    // Results that are returned from the searchCompleter
    var searchResults = [MKLocalSearchCompletion]()
    
    // MARK: - VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
    }
    
    // MARK: - Table View Data Source
    
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
        if let controller = segue.destination as? CityWeatherViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let result = searchResults[indexPath.row]
                let searchRequest = MKLocalSearch.Request(completion: result)
                
                let search = MKLocalSearch(request: searchRequest)
                search.start { (response, _) in
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
                                        
                    controller.city = (name, placemarkTitle, lat, lon, timeZone)
                    controller.searchDelegate = self
                    
                    // Check that the city exist in list of saved city, if exist need to hide add button
                    controller.isTopButtonHidden = (cancel: false, add: CoreDataStack.shared.isContainCity(placemarkTitle: placemarkTitle))
                }
            }
        }
    }
    
// MARK: - CitySearchResultVC Delegate
    
    func dismissCitySearchResultVC() {
        self.searchBarDelegate?.cleanSearchBar()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Search Controller Extensions

extension CitySearchResultVC: UISearchControllerDelegate {
        func didDismissSearchController(_ searchController: UISearchController) {
            searchController.searchBar.text = nil
        }
    func willPresentSearchController(_ searchController: UISearchController) {
        self.searchBarDelegate?.endEditingTableView()
    }
}

extension CitySearchResultVC: UISearchBarDelegate {
    
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
