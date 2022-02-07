//
//  LoginVC.swift
//  FoodApp
//
//  Created by OPSolutions on 2/3/22.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController{
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        pageReset()
    }
    
    @IBAction func loginAction(_ sender: Any) {
        signInWithFirebase(email: usernameTextField.text!, password: passwordTextField.text!)
    }
    
}

extension LoginVC{
    func signInWithFirebase(email: String, password: String){
        print("username: \(usernameTextField.text!)")
        print("password: \(passwordTextField.text!)")
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            if let error = error{
                print(error.localizedDescription)
                return
            }
            self!.checkUserID()
            let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self!.navigationController!.pushViewController(vc, animated: true)
        }
    }
    
    func checkUserID(){
        if Auth.auth().currentUser != nil{
            print("User Signed In \n uid: \(Auth.auth().currentUser!.uid) \n email: \(Auth.auth().currentUser!.email!)")
            UserDefaults.standard.set(true, forKey: "foodAppIsSignedIn")
            UserDefaults.standard.synchronize()
        }
    }
}

extension LoginVC{
    // MARK: - Setup View
    func setupView(){
        loginButton.layer.cornerRadius = 10
    }
    
    // MARK: - Text Field Verification
    @IBAction func usernameChanged(_ sender: Any) {
        textfieldVerification()
    }
    @IBAction func passwordChanged(_ sender: Any) {
        textfieldVerification()
    }
    
    func textfieldVerification(){
        if usernameTextField.text == "" || passwordTextField.text == "" {
            loginButton.isUserInteractionEnabled = false
            loginButton.backgroundColor = .systemGray4
        }
        else{
            loginButton.isUserInteractionEnabled = true
            loginButton.backgroundColor = .systemGreen
        }
    }
    
    //MARK: - Page Reset
    func pageReset(){
        loginButton.isUserInteractionEnabled = false
        loginButton.backgroundColor = .systemGray4
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
}
