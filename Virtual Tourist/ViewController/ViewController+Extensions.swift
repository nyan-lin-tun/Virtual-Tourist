//
//  ViewController+Extensions.swift
//  Virtual Tourist
//
//  Created by Nyan Lin Tun on 08/06/2020.
//  Copyright © 2020 Nyan Lin Tun. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
//    func save() {
//        do {
//            try CoreDataStack.shared().saveContext()
//        } catch {
//            showInfo(withTitle: "Error", withMessage: "Error while saving Pin location: \(error)")
//        }
//    }
}
