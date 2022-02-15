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
    
    var errorMessage = ""
    
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
    // MARK: - Setup View
    func setupView(){
        navigationController?.navigationBar.prefersLargeTitles = false
        loginButton.layer.cornerRadius = 10
    }
    
    //MARK: - Page Reset
    func pageReset(){
        loginButton.isUserInteractionEnabled = false
        loginButton.backgroundColor = .systemGray4
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    //MARK: - Sign In Functions
    func signInWithFirebase(email: String, password: String){
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) { [weak self] authResult, error in
            guard self != nil else { return }
            if let error = error{
                self!.errorMessage = error.localizedDescription
                if error._code == 17011{
                    self!.signUpAlert()
                }
                else{
                    self!.showAlert(title: "Sign In Failed", message: self!.errorMessage)
                }
                return
            }
            self!.signInUser()
        }
    }
    
    fileprivate func signUpAlert() {
        let alert = UIAlertController(title: "Sign In Failed", message: "The email you have entered is not registered, would you like to sign up?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign Up", style: UIAlertAction.Style.default, handler: { _ in
            self.pushToRegisterVC()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func signInUser(){
        print("User Signed In \n uid: \(Auth.auth().currentUser!.uid) \n email: \(Auth.auth().currentUser!.email!)")
        updateUserDefaults()
        popToSplashVC()
    }
    
    fileprivate func updateUserDefaults(){
        UserDefaults.standard.set(true, forKey: "foodAppIsSignedIn")
        UserDefaults.standard.set(usernameTextField.text, forKey: "foodAppIsSignedInUser")
        UserDefaults.standard.synchronize()
    }
    // MARK: - Screen Transition Functions
    fileprivate func popToSplashVC(){
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    fileprivate func pushToRegisterVC(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController!.pushViewController(vc, animated: true)
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
}
