//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Nyan Lin Tun on 06/06/2020.
//  Copyright © 2020 Nyan Lin Tun. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
}
