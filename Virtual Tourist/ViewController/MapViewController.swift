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
    
    @IBOutlet weak var tapToDeletePinsLabel: UILabel!
    
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
    
    private func displayAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Virtual Tourist"
        self.tapToDeletePinsLabel.isHidden = true
        self.navigationItem.rightBarButtonItem = editButtonItem
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
            do {
                try self.createAnnotation(coordinate: coordinate)
            }catch {
                print("error")
            }
        default:
            print("default")
        }
    }
    
    fileprivate func createAnnotation(coordinate: CLLocationCoordinate2D) throws {
        let location = Location(context: dataController.viewContext)
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.creationDate = Date()
        CoreDataStack.saveToCoreData(dataController: self.dataController)
    }
    
    fileprivate func getLocation(annotation: MKAnnotation) throws -> Location? {
        let latitude = annotation.coordinate.latitude
        let longitude = annotation.coordinate.longitude
        let predicate = NSPredicate(format: "latitude == %@ AND longitude == %@", String(latitude), String(longitude))
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        fetchRequest.predicate = predicate
        guard let location = (try dataController.viewContext.fetch(fetchRequest) as! [Location]).first else {
            return nil
        }
        return location
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        self.tapToDeletePinsLabel.isHidden = !editing
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: pinId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinId)
            pinView!.animatesDrop = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoLight)
            pinView!.pinTintColor = UIColor.red
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else {
            return
        }
        mapView.deselectAnnotation(annotation, animated: true)
        print("\(#function) lat \(annotation.coordinate.latitude) lon \(annotation.coordinate.longitude)")
        do {
            if let location = try getLocation(annotation: annotation) {
                if isEditing {
                    dataController.viewContext.delete(location)
                    CoreDataStack.saveToCoreData(dataController: self.dataController)
                    self.mapView.removeAnnotation(annotation)
                }else {
                    GenericNetwork.getPhotos(latitude: annotation.coordinate.latitude, longtitude: annotation.coordinate.longitude)
                    let photoListViewController = storyboard?.instantiateViewController(withIdentifier: "PhotoListViewController") as! PhotoListViewController
                    photoListViewController.dataController = self.dataController
                    photoListViewController.location = location
                    photoListViewController.annotation = annotation
                    self.navigationController?.pushViewController(photoListViewController, animated: true)
                }
            }else {
                self.displayAlert(message: "Cannot get location.")
            }
        } catch {
            fatalError()
        }
    }
}

