//
//  PostLocationViewController.swift
//  OnTheMap
//
//  Created by Owais Gaffas on 27/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class PostLocationViewController : UIViewController, MKMapViewDelegate {
    
    var location: StudentLocation!

    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func finishTapped(_ sender: Any) {
        UdacityAPI.getUserInfo {
            self.location.firstName = UdacityAPI.first
            self.location.lastName = UdacityAPI.last
            UdacityAPI.postLocation(studentLocation: self.location){(error) in
                DispatchQueue.main.async {
                    if error != nil {
                        self.handleErrorMessage(errorMessage: "There was an error performing your request")
                    } else {
                    self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {

        guard let location = location else { return }
        
        let lat = CLLocationDegrees(location.latitude!)
        let long = CLLocationDegrees(location.longitude!)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location.mapString
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    
    func handleErrorMessage(errorMessage: String){
        let errorMessageAlert = UIAlertController(title: "Error!", message: errorMessage, preferredStyle: .alert)
        errorMessageAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(errorMessageAlert, animated: true, completion: nil)
    }
    
}


