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
    
    init(member: Profile) {
        self.member = member
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
        membersCell.configure(member: member)
        return membersCell
    }
}
