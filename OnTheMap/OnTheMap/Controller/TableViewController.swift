//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Owais Gaffas on 15/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class TableViewController : UITableViewController {
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        UdacityAPI.logout {
        }
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func addLocationTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "addLocationFromTable", sender: nil)
    }
    @IBAction func refreshTapped(_ sender: Any) {
        self.updateTable()
    }
  
    
    var studentInformation : [StudentLocation] = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTable()
}
        func updateTable(){
        UdacityAPI.getAllLocation () {(studentsLocations, error) in
            DispatchQueue.main.async {
                
                if error != nil {
                    self.handleErrorMessage(errorMessage: "There was an error performing your request")
                    return
                }
                
                guard studentsLocations != nil else {
                    self.handleErrorMessage(errorMessage: "There was an error loading locations")
                    return
                }
                
                self.studentInformation = studentsLocations!
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInformation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath)
        
        
        let student = studentInformation[indexPath.row]
        cell.textLabel?.text = "\(student.firstName ?? "Loading") \(student.lastName ?? "")"
        cell.detailTextLabel?.text = student.mediaURL ?? ""
        cell.imageView?.image = #imageLiteral(resourceName: "icon_pin") 
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = studentInformation[indexPath.row]
        handleURLError(url: student.mediaURL!)
        UIApplication.shared.open(URL(string: student.mediaURL!)!)
    }
    
    func handleErrorMessage(errorMessage: String){
        let errorMessageAlert = UIAlertController(title: "Falid!", message: errorMessage, preferredStyle: .alert)
        errorMessageAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(errorMessageAlert,animated: true, completion: nil)
    }
    func handleURLError(url: String) -> Bool {
        guard url.contains("https") || url.contains("http") else {
            let errorURL = UIAlertController(title: "Error", message: "Url invaild, please try another", preferredStyle: .alert)
            errorURL.addAction(UIAlertAction(title: "Dismes", style: .default, handler: nil))
            self.present(errorURL, animated: true, completion: nil)
            return false
        }
        return true
    }
    
}

