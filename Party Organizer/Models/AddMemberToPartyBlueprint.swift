//
//  AddMemberToPartyBlueprint.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/24/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import UIKit

class AddMemberToPartyRowBlueprint {
    let party: Party
    let member: Profile
    
    init(party: Party, member: Profile) {
        self.party = party
        self.member = member
    }
}

extension AddMemberToPartyRowBlueprint : CellBlueprint {
    
    var reusableIdentifier: String {
        return "AddMemberTableViewCell"
    }
    
    var selectable: Bool {
        return false
    }
    
    func configure(cell: Cell) -> Cell {
        let addMemberToPartyCell = cell as! AddMemberTableViewCell
        addMemberToPartyCell.configure(party: party, memberThatEntered: member)
        return addMemberToPartyCell
    }
}
