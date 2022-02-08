//
//  HomeVC.swift
//  FoodApp
//
//  Created by OPSolutions on 2/7/22.
//

import UIKit
import FirebaseAuth

class HomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.set(false, forKey: "foodAppIsSignedIn")
            UserDefaults.standard.synchronize()
            backToIntro()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func backToIntro(){
        navigationController?.popToRootViewController(animated: true)
    }
}

