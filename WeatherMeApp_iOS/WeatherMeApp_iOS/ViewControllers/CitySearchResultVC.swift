//
//  CitySearchResultVC.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 4/24/22.
//

import UIKit
import MapKit

class CitySearchResultVC: UITableViewController {
    
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
            
            let lat = coordinate.latitude
            let lon = coordinate.longitude

            print("\(name) \(lat) \(lon)")

        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
// MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openNewCityWeather",
            let nav = segue.destination as? UINavigationController,
            let vc = nav.viewControllers.first as? CityWeatherViewController {
            vc.cityNAme = "Set City Name"
        }

//        if let vc = segue.destination as? ShoppingItemsViewController {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                vc.shoppingList = fetchedResultsController.object(at: indexPath)
//                vc.dataController = dataController
//            }
//        }
    }
}

// MARK: - Search Controller Extensions

extension CitySearchResultVC: UISearchControllerDelegate {
    
}

extension CitySearchResultVC: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        //print("textDidChange \(searchText)")
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
