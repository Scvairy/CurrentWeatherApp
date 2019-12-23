//
//  Created by Timur Sharifyanov on 17/12/2019.
//  Copyright © 2019 Timur Sharifyanov. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class RootTabBarController: UITabBarController {

    //MARK:- Private variables and constants
    private let todayVC = RecordViewController()
    private let historyNavVC = UINavigationController()
    private let historyVC = HistoryViewController()

    private var api: OWMApi = OWMApi(apiKey: Bundle.main.infoDictionary?["OWMApiKey"] as! String)
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()

        manager.activityType = .other
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        manager.distanceFilter = 10_000; //meters
        manager.delegate = self

        return manager
    }()
    private var location: CLLocation! {
        didSet {
            reloadData()
        }
    }

    //MARK:- Internal Functions
    func requestLocation() {
        locationManager.requestLocation()
    }
    func reloadData() {
        NSLog("\(#function)")
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let sself = self else { return }
            sself.api.getCurrentWeather(for: sself.location) { (json, error) in
                guard let json = json else {
                    self?.showError(error, animated: true)
                    return
                }
                self?.todayVC.updateData(with: json)
            }
        }
    }

    //MARK:- Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("TabBar WillAppear")
        requestLocation()
    }

    //MARK:- Private Functions
    private func setup() {
        setViewControllers([todayVC, historyNavVC], animated: false)

        todayVC.root = self
        todayVC.isRefreshable = true
        todayVC.title = "Today".localized()
        if #available(iOS 13.0, *) {
            todayVC.tabBarItem.image = UIImage(systemName: "umbrella")
            todayVC.tabBarItem.selectedImage = UIImage(systemName: "umbrella.fill")
            historyNavVC.tabBarItem.image = UIImage(systemName: "calendar.circle")
            historyNavVC.tabBarItem.selectedImage = UIImage(systemName: "calendar.circle.fill")
        } else {
            todayVC.tabBarItem.image = UIImage(named: "umbrella.tab")
            historyNavVC.tabBarItem.image = UIImage(named: "calendar.tab")
        }

        historyNavVC.setViewControllers([historyVC], animated: false)
        historyVC.title = "History".localized()
    }

    private func showError(_ error: NetworkError?, animated: Bool) {
        guard let error = error else { return }
        let message = error.getText()

        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: "Try Again".localized(),
                style: .default,
                handler: {[weak self] _ in
                    self?.requestLocation()

                }
            )
        )
        alert.addAction(
            UIAlertAction(
                title: "Cancel".localized(),
                style: .default,
                handler: nil
            )
        )
        self.present(alert, animated: true, completion: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return selectedViewController?.preferredStatusBarStyle ?? .default
    }

    override var childForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
}

extension RootTabBarController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            NSLog("LocationManager got location")
            self.location = location
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let error = error as NSError
        NSLog("LocationManager failed with \(error), \(error.userInfo)")
    }
}
