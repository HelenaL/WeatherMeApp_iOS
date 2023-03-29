//
//  CityWeatherViewController.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 3/28/23.
//

import UIKit

class CityWeatherViewController: UIViewController {
    
    var cityNAme: String = "My City Name"

    override func viewDidLoad() {
        super.viewDidLoad()

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
            return 1
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
            return cell
        case Section.hourly.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyWeatherCell", for: indexPath) as! HourlyWeatherCell
            // cell.cityNameLabel.text = String("City \(indexPath.row + 1)")
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
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 0, right: 8)
    }
}
