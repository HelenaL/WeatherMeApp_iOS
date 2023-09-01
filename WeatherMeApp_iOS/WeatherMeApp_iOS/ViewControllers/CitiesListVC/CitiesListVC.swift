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
    @IBOutlet weak var collectionView: UICollectionView!
    
    var container: NSPersistentContainer = CoreDataStack.shared.persistentContainer
    var cities: [City] = []
    var weathersDict: [String:Weather] = [:]
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(newCityAdded(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
        
        cities = CoreDataStack.shared.getCitiesList()
        
        // Setup Search Controller
        let resultsTableController =
                self.storyboard?.instantiateViewController(withIdentifier: "CitySearchResultVC") as? CitySearchResultVC
        
        let searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.delegate = resultsTableController
        searchController.searchResultsUpdater = resultsTableController
        searchController.searchBar.delegate = resultsTableController // Monitor when the search button is tapped.
        searchController.obscuresBackgroundDuringPresentation = true
        
        // Place the search bar in the navigation bar.
        navigationItem.searchController = searchController
            
        // Make the search bar always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
//
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { _ in
            //self.cities = CoreDataStack.shared.getCitiesList()
            //self.collectionView.reloadData()
        }
        
        
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        layoutConfig.showsSeparators = false
        layoutConfig.trailingSwipeActionsConfigurationProvider = { [unowned self] (indexPath) in

//            guard let item = dataSource.itemIdentifier(for: indexPath) else {
//                return nil
//            }

            // 2
            // Create action 1
            let action1 = UIContextualAction(style: .normal, title: "Action 1") { (action, view, completion) in
                print("🥵 Delete this city")
                // 3
                // Handle swipe action by showing alert message
                //handleSwipe(for: action, item: item)

                // 4
                // Trigger the action completion handler
                completion(true)
            }

            action1.backgroundColor = .systemRed
            return UISwipeActionsConfiguration(actions: [action1])
        }


        
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        collectionView.collectionViewLayout = listLayout
        //collectionView.collectionViewLayout = createCollectionViewLayout()

    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            configuration.showsSeparators = false
            configuration.headerMode = .none
            configuration.trailingSwipeActionsConfigurationProvider = { [unowned self] (indexPath) in

    //            guard let item = dataSource.itemIdentifier(for: indexPath) else {
    //                return nil
    //            }

                // 2
                // Create action 1
                let action1 = UIContextualAction(style: .normal, title: "Action 1") { (action, view, completion) in
                    print("🥵 Delete this city")
                    completion(true)
                }
                action1.backgroundColor = .systemRed
                return UISwipeActionsConfiguration(actions: [action1])
            }
           
            //                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0) //8
            return NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
        }

        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        return layout
    }
    
//    func collectionView(_ collectionView: UICollectionView, canPerformPrimaryActionForItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
    
    @objc func newCityAdded(_ notification: Notification) {
        cities = CoreDataStack.shared.getCitiesList()
        self.collectionView.reloadData()
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
    
    func needToReload(_ city: City) -> Bool {
        var wDate: Date?
        var nowDate = Date.now
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
    
    // MARK: - Navigation
    // openCityWeather
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CityWeatherViewController {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                let city = cities[indexPath.row]
                vc.city = (city.name ?? "", city.placemarkTitle ?? "", city.lat, city.long, city.timeZone ?? "EST")
                vc.isTopButtonHidden = (cancel: true, add: true)
            }
        }
    }
}

// MARK: - Collection View Extensions

extension CitiesListVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CitiesListCollectionViewCell", for: indexPath) as! CitiesListCollectionViewCell
        let cellCity = cities[indexPath.row]
        
        getWeatherForCity(cellCity) { weather, city in
            cell.fillWeatherCell(with: city, and: weather)
        } errorBlock: { city in
            cell.timeLabel.text = "something went wrong"
        }
        
        return cell
    }
}

extension CitiesListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row + 1)
    }
}

extension CitiesListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.bounds.size.width - 16, height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 0, right: 8)
    }
    
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [self] (section, _) -> NSCollectionLayoutSection? in
            if section == 0 {
                var layoutConfig = UICollectionLayoutListConfiguration(appearance: .plain)
                layoutConfig.trailingSwipeActionsConfigurationProvider = { [unowned self] (indexPath) in

        //            guard let item = dataSource.itemIdentifier(for: indexPath) else {
        //                return nil
        //            }

                    // Create action 1
                    let action1 = UIContextualAction(style: .normal, title: "Action 1") { (action, view, completion) in
                        print("🥵 Delete this city")
                        completion(true)
                    }

                    action1.backgroundColor = .systemRed
                    return UISwipeActionsConfiguration(actions: [action1])
                }


                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    )
                )
            
                // group
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(120)
                    ),
                    subitem: item,
                    count: 1
                )
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                
                // section
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0) //8
                return section

            }
            return nil
        }
    }
    

    
}
