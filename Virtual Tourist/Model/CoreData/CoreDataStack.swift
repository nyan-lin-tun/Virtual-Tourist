//
//  CoreDataStack.swift
//  Virtual Tourist
//
//  Created by Nyan Lin Tun on 08/06/2020.
//  Copyright © 2020 Nyan Lin Tun. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    

    class func saveToCoreData(dataController: DataController) {
        dataController.viewContext.performAndWait {
            print("In perform and wait")
            if dataController.viewContext.hasChanges {
                print("Has Changes")
                do {
                    print("Saved")
                    try dataController.viewContext.save()
                } catch {
                    print(error.localizedDescription)
                    print("Error while saving.")
                }
            }
        }
    }
}
