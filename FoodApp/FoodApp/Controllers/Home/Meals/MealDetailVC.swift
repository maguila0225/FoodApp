//
//  MealDetailVC.swift
//  FoodApp
//
//  Created by OPSolutions on 2/11/22.
//

import UIKit

class MealDetailVC: UIViewController {

    var mealID = ""
    var mealName = ""
    var mealImage = ""
    
    @IBOutlet weak var mealDetailCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutMealDetailCollectionView()
        mealDetailCollectionView.reloadData()
    }
}

extension MealDetailVC: UICollectionViewDelegate{

}

extension MealDetailVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mealDetailCollectionView.dequeueReusableCell(withReuseIdentifier: MealDetailCell.identifier,
                                                                for: indexPath) as! MealDetailCell
        let url = URL(string: self.mealImage)
        let image = UIImageView().loadImageFromURL(url: url!)
        let name = self.mealName
        let ID = self.mealID
        cell.configure(Image: image, Name: name, ID: ID)
        return cell
    }

}

extension MealDetailVC: UICollectionViewDelegateFlowLayout{
    
    fileprivate func setupCollectionView() {
        mealDetailCollectionView.register(MealDetailCell.nib(), forCellWithReuseIdentifier: MealDetailCell.identifier)
        mealDetailCollectionView.delegate = self
        mealDetailCollectionView.dataSource = self
    }
    
    func layoutMealDetailCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize.height = view.bounds.height
        layout.itemSize.width = view.bounds.width
        layout.scrollDirection = .vertical
        mealDetailCollectionView.showsVerticalScrollIndicator = false
        mealDetailCollectionView.collectionViewLayout = layout
    }
}
