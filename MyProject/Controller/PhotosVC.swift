//
//  PhotosVC.swift
//  VirtualTourist
//
//  Created by Hailah on 01/06/2019.
//  Copyright © 2019 Hailah. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotosVC: UIViewController , NSFetchedResultsControllerDelegate , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout ,UICollectionViewDataSource    {
    
    
    
    

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var refreshButton: UIBarButtonItem!
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    
    var fetchedResultsController: NSFetchedResultsController<Images>!
    var pin : Pin!
    var pagenum = 1
    var DeletingEvrything = false
    
    var context : NSManagedObjectContext {
        return DataController.sharedInstance.viewContext
    }
    
    var isThereImages: Bool {
        return (fetchedResultsController.fetchedObjects?.count ?? 0) != 0
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        collectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    func setupFetchedResultsController() {
        let fetchRequest : NSFetchRequest<Images> = Images.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "pin == %@", pin)
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        collectionView.reloadData()
        do {
            try fetchedResultsController.performFetch()
            if isThereImages {
                self.collectionView.isUserInteractionEnabled = true
            } else {
                refreshButton(self)
            }
        } catch {
                fatalError("error")
            }
        self.indicator.isHidden = true

    }
    
    @IBAction func refreshButton(_ sender: Any) {
        
      self.collectionView.isUserInteractionEnabled = true

        if isThereImages {
            DeletingEvrything = true
            for image in fetchedResultsController.fetchedObjects! {
                context.delete(image)
            }
            try? context.save()
            DeletingEvrything = false
        }
        FlickrAPI.getImagesURLs(with: pin.coordinate, pageNumber: pagenum) { (urls, error, errorMessage) in
            DispatchQueue.main.async {
                
                guard error == nil && errorMessage == nil else {
                    self.alertMessage(title: "Error", message: error?.localizedDescription ?? errorMessage!)
                    
                    self.indicator.isHidden = true
                    self.refreshButton.isEnabled = true
                    return
                }
                
                guard let urls = urls, !urls.isEmpty else {
                    self.alertMessage(message: errorMessage)
                    self.indicator.isHidden = true
                    
                    return
                }
                
                for url in urls {
                    self.indicator.isHidden = true
                    let image = Images(context : self.context)
                    image.imageURL = url
                    image.pin = self.pin
                }
                
                try? self.context.save()
                
            }
        }
        pagenum += 1
        
    }
   
    

    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        collectionView.reloadData()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if let indexPath = indexPath, type == .delete && !DeletingEvrything {
            collectionView.deleteItems(at: [indexPath])
            return
        }
        if let indexPath = indexPath , type == .insert {
            collectionView.insertItems(at: [indexPath])
        }
        
        if let newIndexPath = newIndexPath, let oldIndexPath = indexPath, type == .move {
            collectionView.moveItem(at: oldIndexPath, to: newIndexPath)
            return
        }
        
        if type != .update {
            collectionView.reloadData()
        }
    }
    
}

extension PhotosVC {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let image = fetchedResultsController.object(at: indexPath)
        cell.setImage(image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = fetchedResultsController.object(at: indexPath)
        context.delete(image)
        try? context.save()
    }
}

