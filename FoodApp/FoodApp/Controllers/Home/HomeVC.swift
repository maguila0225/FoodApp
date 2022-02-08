//
//  HomeVC.swift
//  FoodApp
//
//  Created by OPSolutions on 2/8/22.
//

import UIKit
import FirebaseAuth

class HomeVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            setUserDefaults()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    fileprivate func setUserDefaults(){
        UserDefaults.standard.set(false, forKey: "foodAppIsSignedIn")
        UserDefaults.standard.synchronize()
        popToSplashVC()
    }
    fileprivate func popToSplashVC(){
        navigationController?.popToRootViewController(animated: true)
    }
}
