//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Nyan Lin Tun on 25/05/2020.
//  Copyright © 2020 Nyan Lin Tun. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, NSFetchedResultsControllerDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
    var dataController:DataController!
    var pinAnnotation: MKPointAnnotation?
    
    
    var locations:[Location] = []
    
    private func setUpFetchedResult() {
        let fetchRequest:NSFetchRequest<Location> = Location.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptors]
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            self.locations = result
        }
        self.displayAnnotationFromCoreData()
    }
       
    
    private func displayAnnotationFromCoreData() {
        let annotations = self.locations
        self.mapView.addAnnotations(annotations.map {
            LocationAnnotation(location: $0)
        })

    }
    
    private func displayAlert(index: Int) {
        let alert = UIAlertController(title: "Total data \(index)", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpFetchedResult()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.setUpFetchedResult()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
            do {
                try self.createAnnotation(coordinate: coordinate)
            }catch {
                print("error")
            }
        default:
            print("defautl")
        }
        
    }
    
    fileprivate func createAnnotation(coordinate: CLLocationCoordinate2D) throws {
        let location = Location(context: dataController.viewContext)
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.creationDate = Date()
        
        do {
         try dataController.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
}

