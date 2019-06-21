//
//  DataController.swift
//  VirtualTourist
//
//  Created by Hailah on 08/06/2019.
//  Copyright © 2019 Hailah. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    static let sharedInstance = DataController()
    
    let persistentContainer = NSPersistentContainer(name: "VirtualTourist")
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func load(){
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
        }
    }
    
   }
