//
//  CoderExtension.swift
//  FoodApp
//
//  Created by OPSolutions on 2/7/22.
//

import Foundation
import UIKit

extension UIViewController{
    func encodeInfo(inputUser: UserInfo) -> [String: Any]
    {
        do{
            let encodeInfo = try JSONEncoder().encode(inputUser)
            guard let encodedInfo = try JSONSerialization.jsonObject(with: encodeInfo, options: .allowFragments) as? [String: Any] else{
                NSLog("Serialization Fail")
                return [:]
            }
            return encodedInfo
        }
        catch{
            NSLog("Encoding Failed")
            return [:]
        }
    }
    
}
