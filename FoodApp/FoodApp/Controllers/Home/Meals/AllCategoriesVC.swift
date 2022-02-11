//
//  AllCategoriesVC.swift
//  FoodApp
//
//  Created by OPSolutions on 2/11/22.
//

import Foundation
import UIKit

class AllCategoriesVC: UIViewController {
    @IBOutlet weak var categoryCardCollectionView: UICollectionView!
    
    var categoryList: [String] = []
    var categoryImage: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCategoryCardCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categoryCardCollectionView.reloadData()
    }
    
}
extension AllCategoriesVC{
    func setupView(){
        view.layer.cornerRadius = 20
        title = "All Categories"
    }
    
    func setupCategoryCardCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize.height = 215
        layout.itemSize.width = view.bounds.width / 2.0 - 12
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        categoryCardCollectionView.showsVerticalScrollIndicator = false
        categoryCardCollectionView.delegate = self
        categoryCardCollectionView.dataSource = self
        categoryCardCollectionView.register(CategoryCardCell.nib(), forCellWithReuseIdentifier: CategoryCardCell.identifier)
        categoryCardCollectionView.collectionViewLayout = layout
    }
    
}

extension AllCategoriesVC: UICollectionViewDelegate{

}
extension AllCategoriesVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCardCollectionView.dequeueReusableCell(withReuseIdentifier: CategoryCardCell.identifier, for: indexPath) as! CategoryCardCell
        
        let url = URL(string: self.categoryImage[indexPath.row])
        let categoryName = self.categoryList[indexPath.row]
        let categoryImage = UIImageView().loadImageFromURL(url: url!)
        
        cell.configure(Image: categoryImage, Name: categoryName, Count: indexPath.row)
        
        return cell
    }
    
  
}

extension AllCategoriesVC: UICollectionViewDelegateFlowLayout{

}
