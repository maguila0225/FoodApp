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
   
    let magnifier = UIImageView()
    var searchTextField = UITextField()
    var categoriesFromAPI = Categories(categories: [])
    var categoryList: [String] = []
    var categoryImage: [String] = []
    let categoriesURL = theMealDBURL().categoriesURL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getCategory()
        setupCategoryCollectionView()
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
}

extension MealsVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! CategoryCell
        print(selectedCell.categoryLabel.text!)
    }
    
}

extension MealsVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
        categoryCell.configure(with: "\(self.categoryList[indexPath.row])")
        return categoryCell
    }
    
    
}

extension MealsVC: UICollectionViewDelegateFlowLayout{
    
}


