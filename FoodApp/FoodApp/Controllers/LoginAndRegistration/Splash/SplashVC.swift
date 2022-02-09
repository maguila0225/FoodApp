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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("View did appear")
        signedInCheck()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
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
                let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarVC") as! HomeTabBarVC
                 vc.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
