//
//  Location.swift
//  Virtual Tourist
//
//  Created by Nyan Lin Tun on 07/06/2020.
//  Copyright © 2020 Nyan Lin Tun. All rights reserved.
//

import Foundation
import MapKit

class LocationAnnotation: MKPointAnnotation {
    
    var location: Location

    init(location: Location) {
        self.location = location
        super.init()
        self.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
}

