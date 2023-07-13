//
//  CityWeatherViewController.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 3/28/23.
//

import UIKit

protocol CitySearchResultVCDelegate: AnyObject {
    func dismissCitySearchResultVC ()
}

class CityWeatherViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var searchDelegate: CitySearchResultVCDelegate?
    
    var city: (name: String, lat: Double, long: Double) = ("MyCity", 40.86, -74.12) {
        didSet {
            if (collectionView != nil) {
                collectionView.reloadData()
            }
        }
    }
    
    var isTopButtonHidden: (cancel: Bool, add: Bool) = (cancel: true, add: true)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = createCollectionViewLayout()

        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
            return 20
        case Section.daily.rawValue:
            return 10
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case Section.top.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopWeatherCell", for: indexPath) as! TopWeatherCell
                // cell.cityNameLabel.text = String("City \(indexPath.row + 1)")
            cell.delegate = self
            cell.cityNameLabel.text = city.name
            cell.isTopButtonHidden = isTopButtonHidden
            return cell
        case Section.hourly.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyWeatherCell", for: indexPath) as! HourlyWeatherCell
            // cell.cityNameLabel.text = String("City \(indexPath.row + 1)")
            cell.cellConfigurate()
            return cell
        case Section.daily.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyWeatherCell", for: indexPath) as! DailyWeatherCell
                // cell.cityNameLabel.text = String("City \(indexPath.row + 1)")
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopWeatherCell", for: indexPath) as! TopWeatherCell
                // cell.cityNameLabel.text = String("City \(indexPath.row + 1)")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == Section.daily.rawValue {
             return CGSizeMake(self.view.bounds.width, 36)
        } else {
            return CGSizeZero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "WeatherHeaderCollectionReusableView", for: indexPath) as? WeatherHeaderCollectionReusableView {
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
            return CGSize(width: collectionView.bounds.size.width - 16, height: 400)
        case Section.hourly.rawValue:
            return CGSize(width: collectionView.bounds.size.width - 16, height: 140)
        case Section.daily.rawValue:
            return CGSize(width: collectionView.bounds.size.width - 16, height: 50)
        default:
            return CGSize(width: collectionView.bounds.size.width - 16, height: 10)
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
        return UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [self] (section, _) -> NSCollectionLayoutSection? in
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
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
                              
                // return
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
                
                // return
                return section
            }
            return nil
        }
    }
    
}

extension CityWeatherViewController: TopWeatherCellDelegate {
    func cancelAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func addNewCityToWeatherList() {
        print("ADDD City")
        CoreDataStack.shared.addNewCity(name: city.name, lat: city.lat, long: city.long)
        self.searchDelegate?.dismissCitySearchResultVC()
        dismiss(animated: true, completion: nil)
    }
}
