//
//  NetworkMonitor.swift
//  iQuiz
//
//  Created by Amelia Li on 5/14/25.
//

import Foundation
import Network
import UIKit

class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private var lastStatus: NWPath.Status?
    private(set) var isConnected: Bool = true

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if self.lastStatus != path.status {
                    self.lastStatus = path.status
                    self.isConnected = (path.status == .satisfied)
                    self.handleNetworkChange()
                }
            }
        }
        monitor.start(queue: queue)
    }

    private func handleNetworkChange() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first,
              let topVC = window.rootViewController?.topMostViewController() else {
            return
        }

        let alert = UIAlertController(
            title: isConnected ? "Back Online" : "No Internet",
            message: isConnected ? "You're reconnected to the internet." : "Please check your connection.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        topVC.present(alert, animated: true)
    }

    func checkNowManually(completion: @escaping (Bool) -> Void) {
        let manualMonitor = NWPathMonitor()
        let queue = DispatchQueue(label: "ManualNetworkCheck")

        manualMonitor.pathUpdateHandler = { path in
            manualMonitor.cancel()
            DispatchQueue.main.async {
                completion(path.status == .satisfied)
            }
        }

        manualMonitor.start(queue: queue)
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        } else if let nav = self as? UINavigationController {
            return nav.visibleViewController?.topMostViewController() ?? nav
        } else if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        } else {
            return self
        }
    }
}
