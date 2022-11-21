//
//  AppDelegate.swift
//  Media-Access-App
//
//  Created by Robert Bowen on 11/20/22.
//

import Foundation
import CoreData
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {


    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()


}
