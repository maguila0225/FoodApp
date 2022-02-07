//
//  UserModel.swift
//  FoodApp
//
//  Created by OPSolutions on 2/4/22.
//

import Foundation
import CoreLocation

struct UserInfo: Codable {
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var houseNumber: String = ""
    var streetNumber: String = ""
    var streetName: String = ""
    var district: String = ""
    var city: String = ""
    var postalCode: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
    
}


