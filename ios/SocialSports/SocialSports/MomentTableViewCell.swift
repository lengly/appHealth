//
//  SportCircleTableViewCell.swift
//  SocialSports
//
//  Created by 何羿宏 on 15/12/19.
//  Copyright © 2015年 lengly. All rights reserved.
//

import UIKit

class MomentTableViewCell: UITableViewCell {

    @IBOutlet weak var userPhotoImageView: UIImageView!
    
    @IBOutlet weak var usernameLable: UILabel!
    
    @IBOutlet weak var userWordsTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
