//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Nyan Lin Tun on 25/05/2020.
//  Copyright © 2020 Nyan Lin Tun. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var pinAnnotation: MKPointAnnotation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }

    
    
    @IBAction func addPinAction(_ sender: UILongPressGestureRecognizer) {
        
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        if sender.state == .began {
            
        }
        print("Press")
//       switch sender.state {
//       case .began:
//           let pressMapCoordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
//           createPin(forCoordinate: pressMapCoordinate)
//       default:
//           break
//       }
   }
    
}

extension MapViewController: MKMapViewDelegate {
    
}
