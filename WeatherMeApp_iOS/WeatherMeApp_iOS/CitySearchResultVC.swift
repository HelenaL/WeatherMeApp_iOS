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
    
    var matchingItems: [MKMapItem] = []
    
    // MARK: - VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell

        var secondaryTextArray: [String] = []
        if let area = matchingItems[indexPath.row].placemark.administrativeArea {
            secondaryTextArray.append(area)
        }
        
        if let country = matchingItems[indexPath.row].placemark.country {
            secondaryTextArray.append(country)
        }
        
        var content = cell.defaultContentConfiguration()
        content.text = matchingItems[indexPath.row].placemark.name
        content.secondaryText = secondaryTextArray.joined(separator: ", ")
        cell.contentConfiguration = content
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        searchCityByName(name: searchBar.text ?? " ")
    }
}

extension CitySearchResultVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchCityByName(name: text)
    }
}

extension CitySearchResultVC {
    func searchCityByName(name: String) {
        let searchText = name

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
                guard let response = response else {
                    return
                }
                self.matchingItems = response.mapItems
                self.tableView.reloadData()
            }
    }
}
