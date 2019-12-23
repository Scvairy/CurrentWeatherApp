//
//  Created by Timur Sharifyanov on 17/12/2019.
//  Copyright © 2019 Timur Sharifyanov. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CurrentWeather")
        container.loadPersistentStores { (storeDescription, error) in
            print(storeDescription)
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    private var initialLaunch = true
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = RootTabBarController()
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        guard !initialLaunch else {
            initialLaunch = false
            return
        }
        (window!.rootViewController as! RootTabBarController).requestLocation()
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error on context save \(error), \(error.userInfo)")
            }
        }
    }

}

