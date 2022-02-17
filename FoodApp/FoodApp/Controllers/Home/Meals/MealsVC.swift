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
    var thumbnails: [UIImage?] = []
    var mealIDs: [String] = []
    let categoriesURL = theMealDBURL().categoriesURL
    var categorySelection = ""
    var mealSelectionID = ""
    var mealSelectionName = ""
    var mealSelectionImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getCategory()
        setupCategoryCollectionView()
        setupmealsCollectionView()
    }
    
    @IBAction func searchBarTouchDown(_ sender: Any) {
        // to do: search view using first letter search to populate a table
    }

    @IBAction func seeAllCategories(_ sender: Any) {
        presentAllCategoriesVC()
    }
    
}
extension MealsVC{
    func setupView(){
        searchBarOutlet.setLeftPaddingPoints(47)
        searchBarOutlet.addSubview(magnifier)
        searchBarBackground.layer.cornerRadius = 15
        magnifier.frame = CGRect(x: 16, y: 13, width: 24, height: 24)
        magnifier.image = UIImage(systemName: "magnifyingglass")
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
// MARK: - Screen Transition Functions
    fileprivate func presentAllCategoriesVC() {
        let vc = UIStoryboard(name: "Meals", bundle: nil).instantiateViewController(withIdentifier: "AllCategoriesVC") as! AllCategoriesVC
        vc.categoryList = categoryList
        vc.categoryImage = categoryImage
        present(vc, animated: true, completion: nil)
    }
    
    func pushToMealDetailVC(){
        let vc = UIStoryboard(name: "Meals", bundle: nil).instantiateViewController(withIdentifier: "MealDetailVC") as! MealDetailVC
        vc.mealID = mealSelectionID
        vc.mealName = mealSelectionName
        vc.mealImage = mealSelectionImage
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - API Calls
extension MealsVC{

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
        let inputURL = theMealDBURL().mealsPerCategoryURL + self.categoryList[0]
        getMealsFromCategory(url: inputURL)
        DispatchQueue.main.async {
            self.categoryCollectionView.reloadData()
        }
    }
    
    //MARK: - Get Meals From Category
    func getMealsFromCategory(url: String){
        print("meal category search URL: \(url)")
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
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
                mealIDs.append(entry.idMeal)
        }
        DispatchQueue.main.async {
            self.mealsCollectionView.reloadData()
        }
    }
}

//MARK: - Collection View Delegate
extension MealsVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mealsCollectionView {
            print(self.mealIDs[indexPath.row])
            setSelectedMeal(indexPath)
            pushToMealDetailVC()
        }
        
        if collectionView == categoryCollectionView{
            let selectedCell = collectionView.cellForItem(at: indexPath) as! CategoryCell
            categorySelection = selectedCell.categoryLabel.text!
            getMealsFromCategory(url: theMealDBURL().mealsPerCategoryURL + categorySelection)
            clearStoredMeals()
        }
    }
    
    fileprivate func setSelectedMeal(_ indexPath: IndexPath) {
        mealSelectionID = mealIDs[indexPath.row]
        mealSelectionName = mealList[indexPath.row]
        mealSelectionImage = mealImage[indexPath.row]
    }
    
    fileprivate func clearStoredMeals() {
            mealList = []
            mealImage = []
            mealIDs = []
            thumbnails = []
    }
}

//MARK: - Collection View Data Source
extension MealsVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var cellCount = Int()
        if collectionView == mealsCollectionView {
            print("number of \(categorySelection) meals: \(mealList.count)")
            cellCount = mealList.count
        }
        if collectionView == categoryCollectionView {
            print("number of categories: \(categoryList.count)")
            cellCount = categoryList.count
        }
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var returnCell = UICollectionViewCell()
        if collectionView == mealsCollectionView {
            let mealCell = mealsCollectionView.dequeueReusableCell(withReuseIdentifier: MealsCell.identifier,
                                                                   for: indexPath) as! MealsCell
            let mealName = self.mealList[indexPath.row]
            let url = URL(string: self.mealImage[indexPath.row])
            let mealImage = UIImageView().loadImageFromURL(url: url!)
            DispatchQueue.main.async {
                mealCell.configure(with: mealImage, and: mealName)
            }
            returnCell = mealCell
        }
        
        if collectionView == categoryCollectionView{
            let categoryCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier,
                                                                          for: indexPath) as! CategoryCell
                categoryCell.configure(with: "\(self.categoryList[indexPath.row])")
            returnCell = categoryCell
        }
        return returnCell
    }
}

//MARK: - Collection Flow Layout
extension MealsVC: UICollectionViewDelegateFlowLayout{
    func setupmealsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize.height = 272
        layout.itemSize.width = (view.bounds.width/2.0) - 24
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(CategoryCell.nib(), forCellWithReuseIdentifier: CategoryCell.identifier)
        categoryCollectionView.collectionViewLayout = layout
    }

}


