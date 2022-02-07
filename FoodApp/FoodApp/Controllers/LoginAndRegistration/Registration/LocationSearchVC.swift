//
//  LocationSearchVC.swift
//  FoodApp
//
//  Created by OPSolutions on 2/5/22.
//

import UIKit

class LocationSearchVC: UIViewController {

    @IBOutlet weak var confirmAddressButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var addressLabel: UILabel!
    let searchBarImage = UIImageView()
    
    var addressLabelText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addressLabel.text = addressLabelText
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextField.becomeFirstResponder()
    }
    
    @IBAction func confirmAddressAction(_ sender: Any) {
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension LocationSearchVC{
    func setupView() {
        view.layer.cornerRadius = 20
        searchTextField.setLeftPaddingPoints(30)
        searchTextField.textAlignment = .left
        searchBarImage.image = UIImage(systemName: "magnifyingglass")
        searchBarImage.frame = CGRect(x: view.frame.size.width * (6/375),
                                      y: view.frame.size.width * (8/375),
                                      width: view.frame.size.width * (20/375),
                                      height: view.frame.size.width * (20/375))
        searchBarImage.tintColor = .lightGray
        confirmAddressButton.layer.cornerRadius = 10
        searchTextField.addSubview(searchBarImage)
    }
}
