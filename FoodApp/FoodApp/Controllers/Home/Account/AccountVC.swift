//
//  AccountVC.swift
//  FoodApp
//
//  Created by OPSolutions on 2/9/22.
//

import UIKit
import FirebaseAuth

class AccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func signOut(_ sender: Any) {
        signOutAlert(title: "Sign Out", message: "Are you sure you want to sign out?")
    }
}

extension AccountVC{
    
    func signOutAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign Out", style: UIAlertAction.Style.default, handler: { _ in
            self.signOutUser()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func signOutUser(){
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
        UserDefaults.standard.set("", forKey: "foodAppIsSignedInUser")
        UserDefaults.standard.synchronize()
        returnToSplashVC()
    }
    fileprivate func returnToSplashVC(){
        navigationController?.removeFromParent()
        self.tabBarController?.view.removeFromSuperview()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNavVC") as! MainNavVC
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
}
