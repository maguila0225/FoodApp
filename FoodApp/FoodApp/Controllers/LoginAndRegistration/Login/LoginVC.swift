//
//  LoginVC.swift
//  FoodApp
//
//  Created by OPSolutions on 2/3/22.
//

import UIKit

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
        NSLog("login button pressed")
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
