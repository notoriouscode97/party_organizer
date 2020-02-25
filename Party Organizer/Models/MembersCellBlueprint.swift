//
//  MembersCellBlueprint.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/23/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import UIKit


class MembersCellRowBlueprint {
    
    let member: Profile
    let isPartyMemberScreen: Bool
    let party: Party?
    
    init(member: Profile, isPartyMemberScreen: Bool = false, party: Party? = nil) {
        self.member = member
        self.isPartyMemberScreen = isPartyMemberScreen
        self.party = party
    }
}

extension MembersCellRowBlueprint : CellBlueprint {
    
    var reusableIdentifier: String {
        return "membersTableViewCell"
    }
    
    var selectable: Bool {
        return false
    }
    
    func configure(cell: Cell) -> Cell {
        let membersCell = cell as! MembersTableViewCell
        membersCell.configure(member: member, isPartyMemberScreen: isPartyMemberScreen, party: party)
        return membersCell
    }
}
