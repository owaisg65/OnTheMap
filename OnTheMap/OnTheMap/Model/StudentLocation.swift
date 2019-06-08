//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Owais Gaffas on 15/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation



struct StudentLocation : Codable {
    var createdAt : String?
    var firstName : String?
    var lastName : String?
    var latitude : Double?
    var longitude : Double?
    var mapString : String?
    var mediaURL : String?
    var objectId : String?
    var uniqueKey : String?
    var updatedAt : String?
}

extension StudentLocation {
    init(mapString: String, mediaURL: String) {
        self.mapString = mapString
        self.mediaURL = mediaURL
    }
}
