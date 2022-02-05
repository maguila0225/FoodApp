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
    
    var userAddress = Address()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fillInAddress()
    }
    
    @IBAction func locationButtonTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
        vc.selectionDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        
    }
    
}

extension RegisterVC{
    // MARK: Setup View
    func setupView() {
        registerButton.isUserInteractionEnabled = false
        registerButton.backgroundColor = .systemGray4
        setupUI()
    }
    
    func setupUI() {
        personImage.layer.cornerRadius = personImage.frame.size.width / 2
        personImage.layer.borderWidth = 5
        personImage.layer.borderColor = UIColor.lightGray.cgColor
        registerButton.layer.cornerRadius = 10
    }
    
    //MARK: - Text Field Verification
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
    
    func textfieldVerification(){
        if (firstName.text == "" ||
            lastName.text == "" ||
            email.text == "" ||
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
    
    // MARK: - Fill in User Address
    func fillInAddress(){
        houseNumber.text = userAddress.streetNumber
        street.text = userAddress.streetName
        district.text = userAddress.district
        city.text = userAddress.city
        postalCode.text = userAddress.postalCode
    }
    
    // MARK: - Page Reset
    func pageReset(){
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

// MARK: - Pass Location Data Delegate
extension RegisterVC: PassLocationDelegate{
    func passLocation(userAddress: Address) {
        self.userAddress = userAddress
    }
}
