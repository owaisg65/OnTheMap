//
//  File.swift
//  OnTheMap
//
//  Created by Owais Gaffas on 15/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class MapViewController : UIViewController,  MKMapViewDelegate {
    
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    
    
    @IBAction func logutOutTapped(_ sender: UIBarButtonItem) {
        UdacityAPI.logout {
        }
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        self.updataMap()
    }
    
    
    @IBAction func addLocationTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "addLocationFromMap", sender: nil)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updataMap()
    }
    func updataMap(){
        self.indicator.startAnimating()
        UdacityAPI.getAllLocation () {(studentsLocations, error) in
            DispatchQueue.main.async {
                
                if error != nil {
                    self.handleErrorMessage(errorMessage: "There was an error performing your request")
                }
                
                var annotations = [MKPointAnnotation] ()
                
                
                guard let locationsArray = studentsLocations else {
                    self.handleErrorMessage(errorMessage: "There was an error loading locations")
                    return
                }
                
                for locationStruct in locationsArray {
                    
                    let long = CLLocationDegrees (locationStruct.longitude ?? 0)
                    let lat = CLLocationDegrees (locationStruct.latitude ?? 0)
                    
                    let coords = CLLocationCoordinate2D (latitude: lat, longitude: long)
                    
                    let mediaURL = locationStruct.mediaURL ?? " "
                    let first = locationStruct.firstName ?? " "
                    let last = locationStruct.lastName ?? " "
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coords
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    annotations.append (annotation)
                }
                self.MapView.addAnnotations (annotations)
                self.indicator.stopAnimating()
            }
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                handleURLError(url: toOpen)
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    func handleURLError(url: String) -> Bool {
        guard url.contains("https") || url.contains("http") else {
            let errorURL = UIAlertController(title: "Error", message: "Url invaild", preferredStyle: .alert)
            errorURL.addAction(UIAlertAction(title: "Dismes", style: .default, handler: nil))
            self.present(errorURL, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func handleErrorMessage(errorMessage: String){
        let errorMessageAlert = UIAlertController(title: "Falid!", message: errorMessage, preferredStyle: .alert)
        errorMessageAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(errorMessageAlert, animated: true, completion: nil)
    }
}
