//
//  ViewController.swift
//  OnTheMap
//
//  Created by Owais Gaffas on 15/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameTextFileds.delegate = self
        self.passwordTextFileds.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: OUTLET
    
    @IBOutlet weak var usernameTextFileds: UITextField!
    @IBOutlet weak var passwordTextFileds: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    // MARK: ACTION
    
    @IBAction func loginTappedButton(_ sender: Any) {
        let username = usernameTextFileds.text
        let password = passwordTextFileds.text
        
        if (username!.isEmpty) || (password!.isEmpty) {
            handleErrorMessage(errorMessage: "Please enter your email and password")
        }
        else
        {
            self.indicator.startAnimating()
            UdacityAPI.login(username: username, password: password){(loginSuccess, key, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        self.handleErrorMessage(errorMessage: "There was an error performing your request")
                    }
                    if !loginSuccess {
                        self.handleErrorMessage(errorMessage: "Email or Password is incorrect")
                    } else {
                        self.performSegue(withIdentifier: "login", sender: nil)
                        self.indicator.stopAnimating()
                        self.usernameTextFileds.text = ""
                        self.passwordTextFileds.text = ""
                    }
                }
            }
        }
    }
    @IBAction func signUpTappedbutton(_ sender: Any) {
        guard let signUpURL = URL(string: "https://auth.udacity.com/sign-up") else {
            self.handleErrorMessage(errorMessage: "Url is invaild!")
            return
        }
        UIApplication.shared.open(signUpURL, options: [:], completionHandler: nil)
    }
    
    
    
    func handleErrorMessage(errorMessage: String){
        let errorMessageAlert = UIAlertController(title: "Error!", message: errorMessage, preferredStyle: .alert)
        errorMessageAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.indicator.stopAnimating()
        self.present(errorMessageAlert, animated: true, completion: nil)
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


