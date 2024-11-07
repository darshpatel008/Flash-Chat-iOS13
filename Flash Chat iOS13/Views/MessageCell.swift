//
//  MessageCellTableViewCell.swift
//  Flash Chat iOS13
//
//  Created by Darsh viroja  on 15/09/24.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import UIKit

class MessageCellTableViewCell: UITableViewCell {
    

    @IBOutlet weak var messageBubble: UIView!
    
    
    @IBOutlet weak var label: UILabel!
    
    
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var leftImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
