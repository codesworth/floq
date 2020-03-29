//
//  CommentAlternateCell.swift
//  Floq
//
//  Created by OZE-Shadrach on 3/28/20.
//  Copyright © 2020 Arun Nagarajan. All rights reserved.
//

import UIKit

class CommentAlternateCell: UITableViewCell {

    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var commentlable: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 15
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ comment:Comment){
        timelbl.text = comment.timestamp.localize()
       usernameLabel.text = comment.commentor
        profileImageView.setAvatar(uid: comment.commentorID)
        commentlable.text = comment.body
    }
    
}
