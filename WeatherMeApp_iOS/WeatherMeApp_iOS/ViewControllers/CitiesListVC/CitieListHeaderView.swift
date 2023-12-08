//
//  CitieListHeaderView.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 11/29/23.
//

import UIKit

class CitieListHeaderView: UIView {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    /// Show label about network status if there is problem with internet connection, otherwise to hide it
    /// - Parameter needToShow: true if there is internet connection, otherwise is false
    
    func showNetworkStatus(needToShow: Bool, completion: @escaping () -> Void) {
        let animationDuration = 0.8
        statusLabel.alpha = needToShow ? 0 : 1
        dateLabel.alpha = needToShow ? 0 : 1
        
        UIView.animate(withDuration: animationDuration) {
            self.statusLabel.alpha = needToShow ? 1 : 0
            self.dateLabel.alpha = needToShow ? 1 : 0
            completion()
        }
    }

}
