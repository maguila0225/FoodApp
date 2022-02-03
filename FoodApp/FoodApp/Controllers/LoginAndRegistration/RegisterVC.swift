//
//  RegisterVC.swift
//  FoodApp
//
//  Created by OPSolutions on 2/3/22.
//

import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var houseNumber: UITextField!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var district: UITextField!
    @IBOutlet weak var postalCode: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirmation: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        pageReset()
    }
    
    @IBAction func registerAction(_ sender: Any) {
        
    }
    
    @IBAction func getLocationAction(_ sender: Any) {
        
    }
    
}

extension RegisterVC{
    
    @IBAction func firstNameChange(_ sender: Any) {
        textfieldVerification()
    }
    @IBAction func lastNameChange(_ sender: Any) {
        textfieldVerification()
    }
    
    @IBAction func emailChange(_ sender: Any) {
        textfieldVerification()
    }
    
    @IBAction func houseChange(_ sender: Any) {
        textfieldVerification()
    }
    
    @IBAction func streetChange(_ sender: Any) {
        textfieldVerification()
    }
    
    @IBAction func postalCodeChange(_ sender: Any) {
        textfieldVerification()
    }
    
    @IBAction func districtChange(_ sender: Any) {
        textfieldVerification()
    }
    
    @IBAction func cityChange(_ sender: Any) {
        textfieldVerification()
    }
    
    @IBAction func passwordChange(_ sender: Any) {
        textfieldVerification()
    }
    
    @IBAction func confirmPasswordChange(_ sender: Any) {
        textfieldVerification()
    }
    
    func setupUI() {
        personImage.layer.cornerRadius = personImage.frame.size.width / 2
        personImage.layer.borderWidth = 5
        personImage.layer.borderColor = UIColor.lightGray.cgColor
        registerButton.layer.cornerRadius = 10
    }
    
    func textfieldVerification(){
        if (firstName.text == "" ||
            lastName.text == "" ||
            email.text == "" ||
            houseNumber.text == "" ||
            street.text == "" ||
            district.text == "" ||
            postalCode.text == "" ||
            city.text == "" ||
            password.text == "" ||
            passwordConfirmation.text == ""){
            registerButton.isUserInteractionEnabled = false
            registerButton.backgroundColor = .systemGray4
        }
        else{
            registerButton.isUserInteractionEnabled = true
            registerButton.backgroundColor = .systemGreen
        }
    }
    
    func pageReset(){
        registerButton.isUserInteractionEnabled = false
        registerButton.backgroundColor = .systemGray4
        firstName.text = ""
        lastName.text = ""
        email.text = ""
        houseNumber.text = ""
        street.text = ""
        district.text = ""
        postalCode.text = ""
        city.text = ""
        password.text = ""
        passwordConfirmation.text = ""
    }
}
