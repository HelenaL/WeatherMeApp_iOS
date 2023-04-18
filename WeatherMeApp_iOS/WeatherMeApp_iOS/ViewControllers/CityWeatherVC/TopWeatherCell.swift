//
//  TopWeatherCell.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 3/28/23.
//

import UIKit

protocol TopWeatherCellDelegate: AnyObject {
    func cancelAction ()
    func addNewCityToWeatherList()
}

class TopWeatherCell: UICollectionViewCell {
    
    var isTopButtonHidden: Bool = true {
        didSet {
            cancelButton.isHidden = isTopButtonHidden
            addButton.isHidden = isTopButtonHidden
        }
    }
    weak var delegate: TopWeatherCellDelegate?
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.delegate?.cancelAction()
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        self.delegate?.addNewCityToWeatherList()
    }

}
