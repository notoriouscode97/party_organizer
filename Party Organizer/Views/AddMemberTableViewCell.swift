//
//  AddMemberTableViewCell.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/24/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import UIKit

class AddMemberTableViewCell: UITableViewCell {
    @IBOutlet weak var partyNameLabel: UILabel!
    @IBOutlet weak var checkMarkImageView: UIImageView!

    var memberThatEntered: Profile?
    var containedInParty: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        checkMarkImageView.isHidden = true
        selectionStyle = .none
    }
    
    func configure(party: Party, memberThatEntered: Profile) {
        partyNameLabel.text = party.name
        
        let containsElement = party.members.contains(where: {
            $0.id == memberThatEntered.id
        })
        if containsElement {
            checkMarkImageView.isHidden = false
            containedInParty = true
        }
        
    }
}

//MARK: Cell

extension AddMemberTableViewCell : Cell {
    
    var isSelectable: Bool {
        get { return false }
        set { }
    }
}
