//
//  UserModel.swift
//  FoodApp
//
//  Created by OPSolutions on 2/4/22.
//

import Foundation
import CoreLocation

struct User{
    var email: String = ""
    var password: String = ""
    var Info: UserInfo
}

struct UserInfo{
    var firstName: String = ""
    var lastName: String = ""
    var address: Address
}

struct Address{
    var houseNumber: String = ""
    var streetNumber: String = ""
    var streetName: String = ""
    var district: String = ""
    var city: String = ""
    var postalCode: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
}
