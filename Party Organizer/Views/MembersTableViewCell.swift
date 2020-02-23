//
//  MembersTableViewCell.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/23/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import UIKit

class MembersTableViewCell: UITableViewCell {
   
    @IBOutlet weak var profileImageView: CustomImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        selectionStyle = .none
    }
    
    func configure(member: Profile) {
        nameLabel.text = member.username
        
        guard let photo = member.photo, let url = URL(string: photo) else { return }
        profileImageView.setRounded()
        profileImageView.setImage(with: url, urlString: photo, placeholder: UIImage(named: "placeholder"), isAnimated: true)
    }
}

//MARK: Cell

extension MembersTableViewCell : Cell {
    
    var isSelectable: Bool {
        get { return false }
        set { }
    }
}
