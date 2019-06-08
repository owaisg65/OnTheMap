//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Owais Gaffas on 27/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController : UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.placeTextFiled.delegate = self
        self.linkTextFiled.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var placeTextFiled: UITextField!
    @IBOutlet weak var linkTextFiled: UITextField!
    
    @IBAction func CancelTapped(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func findLocationTapped(_ sender: Any) {
        self.indicator.startAnimating()
        let location = placeTextFiled.text
        let link = linkTextFiled.text
        if (location!.isEmpty) || (link!.isEmpty) {
            handleErrorMessage(errorMessage: "Please Enter Your Location and Website")
            return
        }
        
        let studentLocation = StudentLocation(mapString: location!, mediaURL: link!)
        geocodeCoordinates(studentLocation)
        
    }
    
    func geocodeCoordinates(_ studentLocation: StudentLocation) {
        
        CLGeocoder().geocodeAddressString(studentLocation.mapString!) { (placeMark, error) in
            DispatchQueue.main.async {
                if error != nil {
                    self.handleErrorMessage(errorMessage: "Location Not Found")
                    return
                }
                else {
                    guard let firstLocation = placeMark?.first?.location else { return }
                    
                    var location = studentLocation
                    location.latitude = firstLocation.coordinate.latitude
                    location.longitude = firstLocation.coordinate.longitude
                    self.performSegue(withIdentifier: "addToPostSegue", sender: location)
                    self.indicator.stopAnimating()
                }
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addToPostSegue", let viewController = segue.destination as? PostLocationViewController {
            viewController.location = (sender as! StudentLocation)
        }
    }
    
    
    func handleErrorMessage(errorMessage: String){
        let errorMessageAlert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        errorMessageAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(errorMessageAlert, animated: true, completion: nil)
        self.indicator.stopAnimating()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}





