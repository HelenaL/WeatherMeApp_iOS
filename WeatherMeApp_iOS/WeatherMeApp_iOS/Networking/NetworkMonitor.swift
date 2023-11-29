//
//  NetworkMonitor.swift
//  WeatherMeApp_iOS
//
//  Created by Lenochka on 11/28/23.
//

import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let networkMonitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true
    var onNetworkStatusChange: ((NWPath.Status) -> Void)?
    
    /// Start monitoring network status
    
    func startMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive
            self?.onNetworkStatusChange?(path.status)
            
            if path.status == .satisfied {
                print("We're connected!")
                
                // post connected notification
            } else {
                print("No connection.")
                // post disconnected notification
            }
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        networkMonitor.start(queue: queue)
    }
    
    /// Stop monitoring network status
    
    func stopMonitoring() {
        networkMonitor.cancel()
    }
    
}
