//
//  ChatBubbleCell.swift
//  FoodApp
//
//  Created by OPSolutions on 2/17/22.
//

import UIKit

class ChatBubbleCell: UITableViewCell {
    
    static let identifier = "ChatBubbleCell"

    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var messageBackground: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
    
    var trailingConstraint: NSLayoutConstraint!
    var leadingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBackground.layer.cornerRadius = 10
    }
    
    override var frame: CGRect {
           get {
               return super.frame
           }
           set (newFrame) {
               var frame = newFrame
               frame.size.width = UIScreen.main.bounds.width * 1
               super.frame = frame
           }
       }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    static func nib() -> UINib{
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
    public func configure(sender: String, message: String, timestamp: String, user: String){
        timestampLabel.text = timestamp
        messageLabel.text = message
        senderLabel.text = sender
        trailingConstraint = messageBackground.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        leadingConstraint = messageBackground.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        if user == sender{
            messageBackground.backgroundColor = .tintColor
            leadingConstraint.isActive = true
        }
        else{
            messageBackground.backgroundColor = .secondarySystemBackground
            trailingConstraint.isActive = true
        }
    }
    
}
