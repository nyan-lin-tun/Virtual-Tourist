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
        switch sender.state {
        case .began:
            self.pinAnnotation = MKPointAnnotation()
            self.pinAnnotation!.coordinate = coordinate
            print("\(#function) Coordinate: \(coordinate.latitude),\(coordinate.longitude)")
            self.mapView.addAnnotation(self.pinAnnotation!)
        case .changed:
            self.pinAnnotation!.coordinate = coordinate
        case .ended:
            print("ended")
        default:
            print("defautl")
        }
        
    }
    
    fileprivate func createAnnotation() {
        
    }
    
    
    

    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
}
