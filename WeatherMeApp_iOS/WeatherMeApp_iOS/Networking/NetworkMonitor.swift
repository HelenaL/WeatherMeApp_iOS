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
    private var status: NWPath.Status = .satisfied
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true
    var onNetworkStatusChange: ((NWPath.Status) -> Void)?
    var lastOnlineTime: Date?
    
    /// Start monitoring network status
    
    func startMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            guard let sSelf = self else { return }
            if path.status != sSelf.status && [NWPath.Status.satisfied, NWPath.Status.unsatisfied].contains(path.status) {
                sSelf.status = path.status
                sSelf.lastOnlineTime = Date.now
                sSelf.isReachableOnCellular = path.isExpensive
                sSelf.onNetworkStatusChange?(sSelf.status)
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
