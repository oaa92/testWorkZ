//
//  AppDelegate.swift
//  testWorkZx
//
//  Created by Анатолий on 06/04/2020.
//  Copyright © 2020 Anatoliy Odinetskiy. All rights reserved.
//

import CoreData
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack(modelName: "testWorkZx")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        updateAccountantTypes()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let controller = createTabBarController()
        window?.rootViewController = controller
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveContext()
    }

    func createTabBarController() -> UITabBarController {
        let employeesTableViewController = EmployeesTableViewController()
        employeesTableViewController.coreDataStack = coreDataStack
        employeesTableViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("list", comment: ""),
                                                               image: UIImage(named: "employees"),
                                                               tag: 0)

        let galleryViewController = GalleryControllerView()
        galleryViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("gallery", comment: ""),
                                                        image: UIImage(named: "gallery"),
                                                        tag: 1)

        let serviceViewController = ServiceViewController()
        serviceViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("service", comment: ""),
                                                        image: UIImage(named: "service"),
                                                        tag: 2)

        let employeesNavigationController = UINavigationController(rootViewController: employeesTableViewController)
        let galleryNavigationController = UINavigationController(rootViewController: galleryViewController)
        let serviceNavigationController = UINavigationController(rootViewController: serviceViewController)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [employeesNavigationController,
                                            galleryNavigationController,
                                            serviceNavigationController]
        return tabBarController
    }
    
    func updateAccountantTypes() {
        let names = ["payroll", "materialAccounting"]
        let service = AccountantService()
        service.context = coreDataStack.managedContext
        for name in names {
            if service.fetchType(by: name) == nil {
                let type = AccountantType(context: coreDataStack.managedContext)
                type.name = name
            }
        }
        coreDataStack.saveContext()
    }
}
