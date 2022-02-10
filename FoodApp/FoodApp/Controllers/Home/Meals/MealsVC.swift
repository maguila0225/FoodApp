//
//  HomeVC.swift
//  FoodApp
//
//  Created by OPSolutions on 2/8/22.
//

import UIKit

class MealsVC: UIViewController {
    
    @IBOutlet weak var searchBarBackground: UIView!
    @IBOutlet weak var searchBarOutlet: UITextField!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var mealsCollectionView: UICollectionView!
    
    let magnifier = UIImageView()
    var searchTextField = UITextField()
    var categoriesFromAPI = Categories(categories: [])
    var categoryList: [String] = []
    var categoryImage: [String] = []
    var mealList: [String] = []
    var mealImage: [String] = []
    let categoriesURL = theMealDBURL().categoriesURL
    var categorySelection = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getCategory()
        setupCategoryCollectionView()
        setupmealsCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @IBAction func searchBarTouchDown(_ sender: Any) {
        
    }
    
}
extension MealsVC{
    func setupView(){
        navigationController?.navigationBar.prefersLargeTitles = true
        searchBarOutlet.setLeftPaddingPoints(47)
        searchBarOutlet.addSubview(magnifier)
        searchBarBackground.layer.cornerRadius = 15
        magnifier.frame = CGRect(x: 16, y: 13, width: 24, height: 24)
        magnifier.image = UIImage(systemName: "magnifyingglass")
    }
    
    func setupmealsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 163, height: 272)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16.87
        mealsCollectionView.showsVerticalScrollIndicator = false
        mealsCollectionView.delegate = self
        mealsCollectionView.dataSource = self
        mealsCollectionView.register(MealsCell.nib(), forCellWithReuseIdentifier: MealsCell.identifier)
        mealsCollectionView.collectionViewLayout = layout
    }
    
    func setupCategoryCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 104, height: 42)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8.5
        
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(CategoryCell.nib(), forCellWithReuseIdentifier: CategoryCell.identifier)
        categoryCollectionView.collectionViewLayout = layout
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
        getCategoryList(pulledCategories)
    }
    
    fileprivate func getCategoryList(_ pulledCategories: Categories) {
        let categoryCount = pulledCategories.categories.count
        for i in 0...(categoryCount - 1) {
            let entry = pulledCategories.categories[i] as CategoryDetail
            categoryList.append(entry.strCategory)
            categoryImage.append(entry.strCategoryThumb)
        }
        DispatchQueue.main.async {
            self.categoryCollectionView.reloadData()
        }
    }
    
    func getMealsFromCategory(){
        let mealsURL = theMealDBURL().mealsPerCategoryURL + categorySelection
        print("meal category search URL: \(mealsURL)")
        let task = URLSession.shared.dataTask(with: URL(string: mealsURL)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("\(error!.localizedDescription)")
                return
            }
            self.decodeMealPerCategory(data: data)
        })
        task.resume()
    }
    
    fileprivate func decodeMealPerCategory(data: Data){
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
        getMealsList(pulledMeals)
    }

    fileprivate func getMealsList(_ pulledMeals: Meals) {
        let mealCount = pulledMeals.meals.count
        for i in 0...(mealCount - 1) {
            let entry = pulledMeals.meals[i] as MealDetail
            mealList.append(entry.strMeal)
            mealImage.append(entry.strMealThumb)
        }
        DispatchQueue.main.async {
            print("mealList count: \(self.mealList.count)")
            self.mealsCollectionView.reloadData()
        }
    }
}

extension MealsVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mealsCollectionView {
            _ = collectionView.cellForItem(at: indexPath) as! MealsCell
            print(indexPath)
        }
        
        if collectionView == categoryCollectionView{
            let selectedCell = collectionView.cellForItem(at: indexPath) as! CategoryCell
            categorySelection = selectedCell.categoryLabel.text!
            getMealsFromCategory()
        }
    }
    
}

extension MealsVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mealsCollectionView {
            print("number of cells: \(mealList.count)")
            return mealList.count
        }
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == mealsCollectionView {
            let mealCell = mealsCollectionView.dequeueReusableCell(withReuseIdentifier: MealsCell.identifier, for: indexPath) as! MealsCell
            
            return mealCell
        }
        
        let categoryCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        categoryCell.configure(with: "\(self.categoryList[indexPath.row])")
        return categoryCell
    }
    
    
}

extension MealsVC: UICollectionViewDelegateFlowLayout{
    
}


