//
//  RegisterVC.swift
//  FoodApp
//
//  Created by OPSolutions on 2/3/22.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var personImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        personImage.layer.cornerRadius = personImage.frame.size.width / 2
        personImage.layer.borderWidth = 5
        personImage.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    


}
