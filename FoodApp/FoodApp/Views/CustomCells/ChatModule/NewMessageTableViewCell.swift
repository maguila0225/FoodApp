//
//  NewMessageTableViewCell.swift
//  FoodApp
//
//  Created by OPSolutions on 2/15/22.
//

import UIKit

class NewMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var cellFrame: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    
    static let identifier = "NewMessageTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
    }
    
    public func configure(Name: String, Image: UIImage){
        userName.text = Name
        profilePicture.image = Image
    }
    
    static func nib() -> UINib{
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
}
extension NewMessageTableViewCell{
    func setupCell(){
        profilePicture.image = UIImage(systemName: "person")
        contentView.backgroundColor = .systemBackground
    }
}
