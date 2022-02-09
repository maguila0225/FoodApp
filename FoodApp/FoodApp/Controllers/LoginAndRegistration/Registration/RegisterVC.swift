//
//  RegisterVC.swift
//  FoodApp
//
//  Created by OPSolutions on 2/3/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

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
    var errorMessage = ""
    let firestoreDatabase = Firestore.firestore()
    private let storage = Storage.storage().reference()
    var firebaseImageData = UIImage().pngData()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fillInAddress()
    }
    
    @IBAction func addPhotoButtonTapped(_ sender: Any) {
        presentPhotoActionSheet()    }
    
    @IBAction func locationButtonTapped(_ sender: Any) {
        pushLocationVC()
    }
    
    @IBAction func registerAction(_ sender: Any) {
        guard password.text == passwordConfirmation.text else {
            showAlert(title: "Registration Failed", message: "The password you entered does not match the password confirmation")
            return
        }
        updateUserInfo()
    }
}

extension RegisterVC{
    // MARK: - Setup View
    func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = false
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
    
    // MARK: - Fill in User Address
    func fillInAddress(){
        street.text = userInfo.streetNumber + userInfo.streetName
        district.text = userInfo.district
        city.text = userInfo.city
        postalCode.text = userInfo.postalCode
    }
    
    //MARK: - Registration with Firebase
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
        Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: { [self] result, error in
            if error != nil{
                self.errorMessage = error!.localizedDescription
                showAlert(title: "Registration Failed", message: self.errorMessage )
                return
            }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let docRef = self.firestoreDatabase.collection("UserInfo").document(uid)
            docRef.setData(encodedUser)
            uploadImageData(uid: uid)
            pushLoginVC()
        })
    }
    
    //MARK: - Screen Transition Functions
    func pushLocationVC(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
        vc.selectionDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushLoginVC(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Text Field Verification
extension RegisterVC{
    @IBAction func firstNameChange(_ sender: Any) { textfieldVerification() }
    @IBAction func lastNameChange(_ sender: Any) { textfieldVerification() }
    @IBAction func emailChange(_ sender: Any) { textfieldVerification() }
    @IBAction func houseChange(_ sender: Any) { textfieldVerification() }
    @IBAction func streetChange(_ sender: Any) { textfieldVerification() }
    @IBAction func postalCodeChange(_ sender: Any) { textfieldVerification() }
    @IBAction func districtChange(_ sender: Any) { textfieldVerification() }
    @IBAction func cityChange(_ sender: Any) { textfieldVerification() }
    @IBAction func passwordChange(_ sender: Any) { textfieldVerification() }
    @IBAction func confirmPasswordChange(_ sender: Any) { textfieldVerification() }
    
    fileprivate func textfieldVerification(){
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
}

// MARK: - Pass Location Data Delegate
extension RegisterVC: PassLocationDelegate{
    func passLocation(userInfo: UserInfo) {
        self.userInfo = userInfo
    }
}

// MARK: - Photo Selection and Upload
extension RegisterVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picure",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet, animated: true)
    }
    
    fileprivate func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    fileprivate func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        guard let imageData = selectedImage.pngData().self else { return }
        self.firebaseImageData = imageData
        self.personImage.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadImageData(uid: String){
        let reference = "profilePictures/\(uid).png"
        guard firebaseImageData != nil else {
            print("No Profile Picture Selected")
            return }
        storage.child(reference).putData(self.firebaseImageData!,metadata: nil) { _, error in
            guard error == nil else {
                NSLog(error!.localizedDescription)
                return }
        }
    }
}
