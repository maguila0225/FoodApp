//
//  IntroVC.swift
//  FoodApp
//
//  Created by OPSolutions on 2/3/22.
//

import UIKit

class IntroVC: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
    }
}

extension IntroVC{
    func setupView(){
        registerButton.layer.cornerRadius = 10
        loginButton.layer.cornerRadius = 10
    }
}
