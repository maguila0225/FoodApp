//
//  ChatHomeTableViewCell.swift
//  FoodApp
//
//  Created by OPSolutions on 2/11/22.
//

import UIKit

class ChatHomeTableViewCell: UITableViewCell {

    static let identifier = "ChatHomeTableViewCell"
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var latestMessage: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePicture.image = UIImage(systemName: "person")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    public func configure(with text: String){
        
    }
    
    static func nib() -> UINib{
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
}
