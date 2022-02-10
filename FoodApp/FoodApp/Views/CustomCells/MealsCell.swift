//
//  MealsCell.swift
//  FoodApp
//
//  Created by OPSolutions on 2/10/22.
//

import UIKit

class MealsCell: UICollectionViewCell {
    
    static let identifier = "MealsCell"
    
    @IBOutlet weak var mealCellImage: UIImageView!
    @IBOutlet weak var mealCellButton: UIButton!
    @IBOutlet weak var mealCellLabel: UILabel!
    @IBOutlet weak var mealCellBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mealCellBackground.layer.cornerRadius = 20
        mealCellImage.image = UIImage(systemName: "flame")
        mealCellLabel.text = "Put Meal Name Here"
        mealCellLabel.numberOfLines = 2
        mealCellButton.layer.cornerRadius = 10
    }
    
    override var isSelected: Bool {
        didSet {
            
        }
    }
    
    public func configure(with text: String){
       
    }
    
    static func nib() -> UINib{
        return UINib(nibName: self.identifier, bundle: nil)
    }
}
