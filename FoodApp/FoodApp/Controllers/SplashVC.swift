//
//  ViewController.swift
//  FoodApp
//
//  Created by OPSolutions on 2/3/22.
//

import UIKit

class SplashVC: UIViewController {
    var signedInStatus = UserDefaults.standard.bool(forKey: "foodAppIsSignedIn")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("View did appear")
        signedInCheck()
    }
    
}

extension SplashVC{
    func signedInCheck(){
        signedInStatus = UserDefaults.standard.bool(forKey: "foodAppIsSignedIn")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if self.signedInStatus != true {
               let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IntroVC") as! IntroVC
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                 vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
