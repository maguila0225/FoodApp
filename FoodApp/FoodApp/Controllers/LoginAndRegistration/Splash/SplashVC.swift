//
//  ViewController.swift
//  FoodApp
//
//  Created by OPSolutions on 2/3/22.
//

import UIKit

class SplashVC: UIViewController {
    var signedInStatus = UserDefaults.standard.bool(forKey: "foodAppIsSignedIn")
    
    var categoryList: [String] = []
    var categoryImage: [String] = []
    var mealList: [[String]] = []
    var mealImage: [[String]] = []
    var mealIDs: [[String]] = []
    var mealListArray:[String] = []
    var mealImageArray: [String] = []
    var mealIDsArray: [String] = []
    var inputURL: [String] = []
  
    
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
    // MARK: - Sign In Check
    func signedInCheck(){
        signedInStatus = UserDefaults.standard.bool(forKey: "foodAppIsSignedIn")
            if self.signedInStatus != true {
                self.pushIntroVC()
            }
            else {
                self.getCategory()
            }
    }
    
    //MARK: - Get Category
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
        getCategoryList(pulledCategories)
    }
    

    
    fileprivate func getCategoryList(_ pulledCategories: Categories) {
        let categoryCount = pulledCategories.categories.count
        for i in 0...(categoryCount - 1) {
            let entry = pulledCategories.categories[i] as CategoryDetail
            categoryList.append(entry.strCategory)
            categoryImage.append(entry.strCategoryThumb)
        }
        
        for i in 0...(self.categoryList.count - 1){
            inputURL.append(theMealDBURL().mealsPerCategoryURL + self.categoryList[i])
            setMealArraySize()
        }
        loopMealApiCall()
    }
    
    fileprivate func setMealArraySize() {
        mealList.append([])
        mealImage.append([])
        mealIDs.append([])
    }
    
    func loopMealApiCall(){
        for i in 0...(categoryList.count - 1){
            getMealsFromCategory(url: inputURL[i], count: i)
        }
        presentHomeTabBarVC()
    }
    
    func getMealsFromCategory(url: String, count: Int){
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("\(error!.localizedDescription)")
                return
            }
            self.decodeMealPerCategory(data: data, count: count)
        })
        task.resume()
    }
    
    fileprivate func decodeMealPerCategory(data: Data, count: Int){
        var meals: Meals?
        do{
            meals = try JSONDecoder().decode(Meals.self, from: data)
        }
        catch{
            NSLog("failed to convert \(error)")
        }
        guard let pulledMeals = meals else {
            return
        }
        getMealsList(pulledMeals, count: count)

    }
    
    fileprivate func getMealsList(_ pulledMeals: Meals, count: Int) {
        let mealCount = pulledMeals.meals.count
        clearMealsArray(mealCount: mealCount, pulledMeals: pulledMeals, count: count)
    }
    
    fileprivate func clearMealsArray(mealCount: Int, pulledMeals: Meals, count: Int){
        mealListArray = []
        mealImageArray = []
        mealIDsArray = []
        loopMealArray(mealCount: mealCount, pulledMeals: pulledMeals, count: count)
    }
    
    fileprivate func loopMealArray(mealCount: Int, pulledMeals: Meals, count: Int) {
        for i in 0...(mealCount - 1) {
            let entry = pulledMeals.meals[i] as MealDetail
            mealListArray.append(entry.strMeal)
            mealImageArray.append(entry.strMealThumb)
            mealIDsArray.append(entry.idMeal)
        }
        setMealArrays(count)
    }
    
    fileprivate func setMealArrays(_ count: Int) {
        mealList[count] = mealListArray
        mealImage[count] = mealImageArray
        mealIDs[count] = mealIDsArray
    }
    
    //MARK: - Screen Transition Functions
    fileprivate func pushIntroVC(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IntroVC") as! IntroVC
         vc.modalPresentationStyle = .fullScreen
         self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func presentHomeTabBarVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarVC") as! HomeTabBarVC
            let navVC = vc.viewControllers?[0] as! MealsVCNavVCViewController
            let mealVC = navVC.viewControllers[0] as! MealsVC
            self.passApiData(mealVC)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        })
    }
    
    fileprivate func passApiData(_ mealVC: MealsVC) {
        mealVC.categoryList = self.categoryList
        mealVC.categorySelection = self.categoryList[0]
        mealVC.categoryImage = self.categoryImage
        mealVC.mealList = self.mealList
        mealVC.mealImage = self.mealImage
        mealVC.mealIDs = self.mealIDs
    }
}

