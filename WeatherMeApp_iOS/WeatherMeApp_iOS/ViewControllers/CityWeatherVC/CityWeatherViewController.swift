//
//  CityWeatherViewController.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 3/28/23.
//

import UIKit
import CoreLocation
import WeatherKit

protocol CitySearchResultVCDelegate: AnyObject {
    func dismissCitySearchResultVC ()
}

class CityWeatherViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var searchDelegate: CitySearchResultVCDelegate?
    var isTopButtonHidden: (cancel: Bool, add: Bool) = (cancel: true, add: true)
    
    var weather: ParsedWeather?
    var hourlyForecast: [HourWeather] = []
    var dailyForecast: [DayWeather] = []
    
    var city: (name: String, placemarkTitle: String, lat: Double, long: Double, timeZone: String) = ("MyCity", "placemarkTitle", 40.86, -74.12, "EST") {
        didSet {
            WeatherDataCenter.shared.getWeatherForLocation(location: CLLocation(latitude: city.lat, longitude: city.long)) { result in
                switch result {
                case .success(let weather):
                    self.weather = weather
                    self.parse(weather: weather)
                case .failure(let error): 
                    print(error)
                }
            }
            
            if collectionView != nil {
                collectionView.reloadData()
            }
        }
    }
    /// Parse hourly and daily weather forecast in separate arrays 
    /// - Parameter weather: Weather forecast
    
    func parse(weather: ParsedWeather) {
        for idx in 0..<weather.hourlyForecast.count {
            let item = weather.hourlyForecast[idx]
            hourlyForecast.append(item)
        }
        
        for item in weather.dailyForecast {
            dailyForecast.append(item)
        }
        
        if collectionView != nil {
            collectionView.reloadData()
        }
    }
    
    // MARK: - VC Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        collectionView.collectionViewLayout = createCollectionViewLayout()
    }
}

// MARK: - Collection View Extensions
enum Section: Int {
    case top = 0
    case hourly
    case daily
}

extension CityWeatherViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Section.top.rawValue:
            return 1
        case Section.hourly.rawValue:
            return hourlyForecast.count
        case Section.daily.rawValue:
            return dailyForecast.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case Section.top.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopWeatherCell", for: indexPath) as! TopWeatherCell
            cell.delegate = self
            cell.isTopButtonHidden = isTopButtonHidden
            
            if let weather = weather {
                cell.cellConfigurate(weather: weather, timeZone: city.timeZone, cityName: city.name)
            }
            return cell
        case Section.hourly.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyWeatherCell", for: indexPath) as! HourlyWeatherCell
            cell.cellConfigurate(hWeather: hourlyForecast[indexPath.row], timeZone: city.timeZone)
            return cell
        case Section.daily.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyWeatherCell", for: indexPath) as! DailyWeatherCell
            cell.cellConfigurate(dayWeather: dailyForecast[indexPath.row], timeZone: city.timeZone)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopWeatherCell", for: indexPath) as! TopWeatherCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == Section.daily.rawValue {
             return CGSize(width: self.view.bounds.width, height: 36)
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, 
                                                                               withReuseIdentifier: "WeatherHeaderCollectionReusableView",
                                                                               for: indexPath) as? WeatherHeaderCollectionReusableView {
            sectionHeader.sectionLabel.text = "10-DAY FORECAST"
            return sectionHeader
        }
        return UICollectionReusableView()
    }
}

extension CityWeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case Section.top.rawValue:
            return CGSize(width: collectionView.bounds.size.width - 0, height: 400)
        case Section.hourly.rawValue:
            return CGSize(width: collectionView.bounds.size.width - 0, height: 140)
        case Section.daily.rawValue:
            return CGSize(width: collectionView.bounds.size.width - 0, height: 50)
        default:
            return CGSize(width: collectionView.bounds.size.width - 0, height: 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case Section.daily.rawValue:
            return 1
        default:
            return 8
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    /// Create compositional layout for Collection View
    ///
    /// Compositional layout with horizontal layout for hourly weather forecast section
    /// and vertical layout for daily weather forecast section.
    ///
    /// - Returns: Compositional layout
   
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
            if section == 0 {
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
                        heightDimension: .absolute(400)
                    ),
                    subitem: item,
                    count: 1
                )
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                              
                // section
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                              
                return section
                
            } else if section == 1 {
                let item = NSCollectionLayoutItem(
                        layoutSize: NSCollectionLayoutSize(
                          widthDimension: .fractionalWidth(1),
                          heightDimension: .fractionalHeight(1)
                        )
                      )
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 2)
                              
                // group
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(120)
                    ),
                    subitem: item,
                    count: 6
                )
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                      
                // section
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8)
                      
                // return
                return section
                
            } else if section == 2 {
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(50)
                    )
                )
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0)
                                
                // group
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(50)
                    ),
                    subitem: item,
                    count: 1
                )
                
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                                
                  // section
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
                
                // add header section layout
                let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                        heightDimension: .absolute(36))
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: footerHeaderSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
                           
                section.boundarySupplementaryItems = [header]
                
                return section
            }
            return nil
        }
    }
    
}

// MARK: - TopWeatherCell Delegate

extension CityWeatherViewController: TopWeatherCellDelegate {
    
    /// Action for cancel button
    
    func cancelAction() {
        dismiss(animated: true, completion: nil)
    }
    
    /// Action for button to add a new city
    
    func addNewCityToWeatherList() {
        CoreDataStack.shared.addNewCity(name: city.name, placemarkTitle: city.placemarkTitle, lat: city.lat, long: city.long, timeZone: city.timeZone)
        self.searchDelegate?.dismissCitySearchResultVC()
        dismiss(animated: true, completion: nil)
    }
}
