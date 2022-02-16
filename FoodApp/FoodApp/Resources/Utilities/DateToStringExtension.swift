//
//  DateToStringExtension.swift
//  FoodApp
//
//  Created by OPSolutions on 2/16/22.
//

import Foundation

extension Date{
    func toString(format: String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
