//
//  ImageLoaderExtension.swift
//  FoodApp
//
//  Created by OPSolutions on 2/10/22.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageFromURL(url: URL) -> UIImage{
        var returnImage = UIImage()
        if let data = try? Data(contentsOf: url){
            returnImage = UIImage(data: data)!
        }
        return returnImage
    }
}
