//
//  Location+Extension.swift
//  Virtual Tourist
//
//  Created by Nyan Lin Tun on 07/06/2020.
//  Copyright © 2020 Nyan Lin Tun. All rights reserved.
//

import Foundation
import CoreData

extension Location {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
