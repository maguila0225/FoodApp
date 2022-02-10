//
//  HomeVC.swift
//  FoodApp
//
//  Created by OPSolutions on 2/8/22.
//

import UIKit

class MealsVC: UIViewController {
    
    
    @IBOutlet weak var searchBarOutlet: UITextField!
    @IBOutlet weak var categoryScrollView: UIScrollView!
    @IBOutlet weak var categoryBeef: UIView!
    @IBOutlet weak var categoryChicken: UIView!
    @IBOutlet weak var categoryDessert: UIView!
    
    let magnifier = UIImageView()
    var searchTextField = UITextField()
    var categoriesFromAPI = Categories(categories: [])
    let categoriesURL = theMealDBURL().categoriesURL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getCategory()
        
    }
    
    @IBAction func searchBarTouchDown(_ sender: Any) {
        print(categoriesFromAPI)
    }
    
}
extension MealsVC{
    func setupView(){
        navigationController?.navigationBar.prefersLargeTitles = true
        categoryScrollView.showsHorizontalScrollIndicator = false
        searchBarOutlet.setLeftPaddingPoints(47)
        searchBarOutlet.addSubview(magnifier)
        searchBarOutlet.layer.cornerRadius = 20
        magnifier.frame = CGRect(x: 16, y: 13, width: 24, height: 24)
        magnifier.image = UIImage(systemName: "magnifyingglass")
        categoryBeef.layer.cornerRadius = 10
        categoryChicken.layer.cornerRadius = 10
        categoryDessert.layer.cornerRadius = 10
    }
}

// MARK: - API Calls
extension MealsVC{
    func getCategory(){
        let categoriesURL = theMealDBURL().categoriesURL
        let task = URLSession.shared.dataTask(with: URL(string: categoriesURL)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("\(error!.localizedDescription)")
                return
            }
            self.decodeCategory(data: data)
        })
        task.resume()
    }
    
    fileprivate func decodeCategory(data: Data){
        var categories: Categories?
        do{
            categories = try JSONDecoder().decode(Categories.self, from: data)
        }
        catch{
            NSLog("failed to convert \(error)")
        }
        guard let pulledCategories = categories else {
            return
        }
        self.categoriesFromAPI = pulledCategories
    }
}


