//
//  RegisterVC.swift
//  FoodApp
//
//  Created by OPSolutions on 2/3/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

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
    
    var userInfo = UserInfo()
    
    let firestoreDatabase = Firestore.firestore()

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
        
        guard password.text == passwordConfirmation.text else {
            NSLog("mismatch Password")
            return
        }
        updateUserInfo()
    }
    
}

extension RegisterVC{
    func updateUserInfo(){
        userInfo.firstName = self.firstName.text!
        userInfo.lastName = self.lastName.text!
        userInfo.email = self.email.text!
        userInfo.houseNumber = self.houseNumber.text ?? ""
        encodeData()
    }
    
    fileprivate func encodeData(){
        let encodedUser = encodeInfo(inputUser: userInfo)
        
        registerWithFirebase(encodedUser)
    }
    
    fileprivate func registerWithFirebase(_ encodedUser: [String : Any]) {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: { result, error in
            if error != nil{
                NSLog("\(String(describing: error))")
            }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            print("uid: \(Auth.auth().currentUser!.uid)")
            print("email: \(self.email.text!)")
            print("password \(self.password.text!)")
            let docRef = self.firestoreDatabase.collection("UserInfo").document(uid)
            docRef.setData(encodedUser)
        })
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
        street.text = userInfo.streetNumber + userInfo.streetName
        district.text = userInfo.district
        city.text = userInfo.city
        postalCode.text = userInfo.postalCode
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
    func passLocation(userInfo: UserInfo) {
        self.userInfo = userInfo
    }
}
