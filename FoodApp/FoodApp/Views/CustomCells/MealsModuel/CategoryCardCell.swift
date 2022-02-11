//
//  CategoryCardCell.swift
//  FoodApp
//
//  Created by OPSolutions on 2/11/22.
//

import UIKit

class CategoryCardCell: UICollectionViewCell {

    static let identifier = "CategoryCardCell"
    
    @IBOutlet weak var categoryCardBackground: UIView!
    @IBOutlet weak var categoryCardImage: UIImageView!
    @IBOutlet weak var categoryCardName: UILabel!
    @IBOutlet weak var categoryCardCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryCardBackground.layer.cornerRadius = 20
        categoryCardImage.image = UIImage(systemName: "flame")
    }
    
    public func configure(Image: UIImage,Name: String, Count: Int){
            categoryCardImage.image = Image
            categoryCardName.text = Name
            categoryCardCount.text = "\(Count) Items"
    }
    
    static func nib() -> UINib{
        return UINib(nibName: self.identifier, bundle: nil)
    }

}
