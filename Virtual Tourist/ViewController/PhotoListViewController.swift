//
//  PhotoListViewController.swift
//  Virtual Tourist
//
//  Created by Nyan Lin Tun on 08/06/2020.
//  Copyright © 2020 Nyan Lin Tun. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoListViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var dataController:DataController!
    var location: Location!
    var annotation: MKAnnotation?
    var images:[Photo] = []
    var hello:String?
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.focusLocationOnMap()
        self.setUpFetchedResultsController()
        print("Total photo count is \(self.images.count)")
    }
    

    @IBAction func newCollectionAction(_ sender: UIButton) {
        
    }
    
    fileprivate func setUpFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "location == %@", location)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            self.images = result
        }else {
            
        }
    }
    
    fileprivate func focusLocationOnMap() {
        let centerCoordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let coordinateRegion = MKCoordinateRegion(center: centerCoordinate, span: coordinateSpan)
        mapView.setRegion(coordinateRegion, animated: false)
        let annotation = MKPointAnnotation()
        annotation.coordinate = centerCoordinate
        mapView.addAnnotation(annotation)
 
    }

}

extension PhotoListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        
        return photoCell
    }
    
    
}
