//
//  MapVC.swift
//  VirtualTourist
//
//  Created by Hailah on 26/05/2019.
//  Copyright © 2019 Hailah. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapVC: UIViewController , MKMapViewDelegate , NSFetchedResultsControllerDelegate {

    
    @IBOutlet var mapView: MKMapView!
    
    var fetchedResultsController : NSFetchedResultsController<Pin>!
    
    var context : NSManagedObjectContext {
        return DataController.sharedInstance.viewContext
    }
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state != .began { return }
        let touchpoint = sender.location(in: mapView)
        
        let pin = Pin(context: context)
        pin.coordinate = mapView.convert(touchpoint, toCoordinateFrom: mapView)
        try? context.save()
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        API.deleteSession(completion: { (error) in
            if let error = error {
                self.alertMessage(title: "Error", message: error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    
        func setupFetchedResultsController() {
        let fetchRequest : NSFetchRequest<Pin> = Pin.fetchRequest()
            
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            updateMap()
            
        } catch {
            fatalError(error.localizedDescription)
        }
        
    }

    func updateMap() {
        guard  let pins = fetchedResultsController.fetchedObjects else {
            return
        }
        for pin in pins {
            if mapView.annotations.contains(where: { pin.compare(to: $0.coordinate)}) {continue}
            let annotation = MKPointAnnotation()
            annotation.coordinate = pin.coordinate
            mapView.addAnnotation(annotation)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotosVC" {
            let photoVC = segue.destination as! PhotosVC
             photoVC.pin = sender as? Pin
        }
    }
    
    func mapView(_ mapView : MKMapView ,didSelect view : MKAnnotationView){
        let pin = fetchedResultsController.fetchedObjects?.filter { $0.compare(to: view.annotation!.coordinate) }.first!
        performSegue(withIdentifier: "PhotosVC", sender: pin)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateMap()
    }
    
    }


    
    


