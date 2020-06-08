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

class PhotoListViewController: UIViewController {
    
    var dataController:DataController!
    var location: Location!
    var annotation: MKAnnotation!
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var photoCollectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var newCollectionButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpFlowLayout()
        self.focusLocationOnMap()
        self.setUpFetchedResultsController()
        
        let images = fetchedResultsController.fetchedObjects
        if images!.isEmpty {
            if LocalReachability.isConnectedToNetwork() {
                DispatchQueue.main.async {
                    self.handleActivityIndicator(downloading: true)
                }
                GenericNetwork.getPhotos(latitude: annotation.coordinate.latitude, longtitude: annotation.coordinate.longitude, completion: self.photoResponseHandler(photoList:error:))
            }else {
                self.displayAlert(title: "Please connect to internet")
            }
        }
    }
    

    fileprivate func removeAllPhotoFromsCoreData() {
        let photos = fetchedResultsController.fetchedObjects ?? []
        for photo in photos {
            let indexPath = fetchedResultsController.indexPath(forObject: photo)!
            deleteImageOnTap(indexPath)
        }
    }
    
    @IBAction func newCollectionAction(_ sender: UIButton) {
        if LocalReachability.isConnectedToNetwork() {
            self.removeAllPhotoFromsCoreData()
            DispatchQueue.main.async {
                self.handleActivityIndicator(downloading: true)
            }
            GenericNetwork.getPhotos(latitude: annotation.coordinate.latitude, longtitude: annotation.coordinate.longitude, completion: self.photoResponseHandler(photoList:error:))
        }else {
            self.displayAlert(title: "Please connect to the internet")
        }
        
    }
    
    fileprivate func setUpFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "location == %@", location)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed. \(error.localizedDescription)")
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
    
    private func photoResponseHandler(photoList: [PhotoResponse], error: Error?) {
        if error == nil {
            if photoList.isEmpty {
                self.displayAlert(title: "There is no images for current location.")
                self.handleActivityIndicator(downloading: false)
            }else {
                for photo in photoList {
                    GenericNetwork.getPhotoData(imageInfo: photo, completion: self.photoDataResponseHandler(image:error:))
                }
            }
        }else {
            self.displayAlert(title: "Error while trying to get images.")
        }
    }
    
    private func photoDataResponseHandler(image: Data?, error: Error?) {
        if error == nil {
            let photo = Photo(context: dataController.viewContext)
            photo.image = image
            photo.creationDate = Date()
            photo.location = location
            try? dataController.viewContext.save()
            self.handleActivityIndicator(downloading: false)
        }else {
            self.displayAlert(title: "Error while downloading images.")
        }
    }
    
    func handleActivityIndicator(downloading: Bool)  {
        if downloading {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        self.newCollectionButton.isEnabled = !downloading
    }
        
    private func setUpFlowLayout() {
        let space: CGFloat = 4
        // Multiply with 4 (2 for spacing between 3 cells and another 2 for left and right spacing)
        let dimession: CGFloat = (self.view.frame.size.width - (space * 4)) / 3.0
        photoCollectionViewFlowLayout.minimumLineSpacing = 4
        photoCollectionViewFlowLayout.minimumInteritemSpacing = 4
        photoCollectionViewFlowLayout.itemSize = CGSize(width: dimession, height: dimession)
        photoCollectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }

}

extension PhotoListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        let locationImage = fetchedResultsController.object(at: indexPath)
        photoCell.imageView.image = UIImage(data: locationImage.image!)
        return photoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.deleteImageOnTap(indexPath)
    }
    
    fileprivate func deleteImageOnTap(_ indexPath: IndexPath) {
        let photoToDelete = fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(photoToDelete)
        try? dataController.viewContext.save()
    }
    
}


extension PhotoListViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.photoCollectionView.insertItems(at: [newIndexPath!])
            break
        case .delete:
            self.photoCollectionView.deleteItems(at: [indexPath!])
            break
        default:
            break
        }
    }
}
