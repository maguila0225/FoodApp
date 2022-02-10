//
//  CategoryCell.swift
//  FoodApp
//
//  Created by OPSolutions on 2/10/22.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet weak var categoryBackground: UIView!
    
    static let identifier = "CategoryCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryBackground.layer.cornerRadius = 5
        categoryBackground.backgroundColor = .systemBackground
    }
    
    override var isSelected: Bool {
        didSet {
            categoryBackground.backgroundColor = isSelected ? .systemGreen: .systemBackground
            categoryLabel.textColor = isSelected ? .systemBackground: .label
        }
    }
    
    public func configure(with text: String){
        categoryLabel.text = text
    }
    
    static func nib() -> UINib{
        return UINib(nibName: self.identifier, bundle: nil)
    }
}
