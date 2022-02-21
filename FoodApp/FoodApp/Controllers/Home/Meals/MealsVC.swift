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
    var categoryList: [String] = []
    var categoryImage: [String] = []
    var mealList: [[String]] = []
    var mealImage: [[String]] = []
    var mealIDs: [[String]] = []
    var mealListContainer: [String] = []
    var mealImageContainer: [String] = []
    var mealIDsContainer: [String] = []
    let categoriesURL = theMealDBURL().categoriesURL
    var categorySelection = ""
    var categorySelectionID: Int = 0
    var imageCache = NSCache<NSString, NSData>()
    //    [String:UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCategoryCollectionView()
        setupmealsCollectionView()
        print("categoryListCount \(categoryList.count)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.initialMealCollectionViewContents()
            self.mealsCollectionView.reloadData()
        }
    }
    
    @IBAction func searchBarTouchDown(_ sender: Any) {
        
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
    
    func initialMealCollectionViewContents(){
        mealListContainer = mealList[0]
        mealImageContainer = mealImage[0]
        mealIDsContainer = mealIDs[0]
    }
    
    // MARK: - Screen Transition Functions
    fileprivate func presentAllCategoriesVC() {
        let vc = UIStoryboard(name: "Meals", bundle: nil).instantiateViewController(withIdentifier: "AllCategoriesVC") as! AllCategoriesVC
        vc.categoryList = categoryList
        vc.categoryImage = categoryImage
        present(vc, animated: true, completion: nil)
    }
    
}

//MARK: - Collection View Delegate
extension MealsVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mealsCollectionView {
            
        }
        
        if collectionView == categoryCollectionView{
            clearContainers(indexPath)
            self.mealsCollectionView.reloadData()
        }
    }
    
    func clearContainers(_ indexPath: IndexPath){
        mealListContainer = []
        mealImageContainer = []
        mealIDsContainer = []
        getContainerElements(indexPath)
    }
    
    func getContainerElements(_ indexPath: IndexPath) {
        mealListContainer = mealList[indexPath.row]
        mealImageContainer = mealImage[indexPath.row]
        mealIDsContainer = mealIDs[indexPath.row]
    }
    
}

//MARK: - Collection View Data Source
extension MealsVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var cellCount = Int()
        if collectionView == mealsCollectionView {
            print("number of meals: \(mealListContainer.count)")
            cellCount = mealListContainer.count
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
            
            let cellIdentifier = mealIDsContainer[indexPath.row]
            mealCell.cellID = cellIdentifier
            
            mealCell.mealCellImage.image = UIImage(systemName: "flame")
            
            let mealName = self.mealListContainer[indexPath.row]
            let mealImage = loadMealImage(indexPath: indexPath,
                                          mealCell: mealCell,
                                          cellIdentifier: cellIdentifier)
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
    
    fileprivate func loadMealImage(indexPath: IndexPath, mealCell: MealsCell, cellIdentifier: String) -> UIImage {
        let url = URL(string: mealImageContainer[indexPath.row])!
        let cacheURL = mealImageContainer[indexPath.row]
        if let cachedImage = imageCache.object(forKey: cacheURL as NSString){
            let imageData = cachedImage as Data
            let mealImage = UIImage(data: imageData)!
            return mealImage
        }
        else{
            var downloadedMealImage = UIImage(systemName: "flame")
            if (mealCell.cellID == cellIdentifier){
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let imageData = data, error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    let cacheData = imageData as NSData
                    self.imageCache.setObject(cacheData, forKey: cacheURL as NSString)
                    downloadedMealImage = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        mealCell.mealCellImage.image = UIImage(data: imageData)!
                    }
                }
                task.resume()
                return downloadedMealImage!
            }
            else{
                return downloadedMealImage!
            }
        }
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


