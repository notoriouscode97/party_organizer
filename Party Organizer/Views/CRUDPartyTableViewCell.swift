//
//  CRUDPartyTableViewCell.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/24/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import UIKit

class CRUDPartyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memberName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        selectionStyle = .none
    }
    
    func configure(member: Profile) {
        memberName.text = member.username
    }
}

//MARK: Cell

extension CRUDPartyTableViewCell : Cell {
    
    var isSelectable: Bool {
        get { return false }
        set { }
    }
}
