//
//  ProfileImageTableViewCell.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/23/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import UIKit

class ProfileImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: CustomImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.setRounded()
    }

}
