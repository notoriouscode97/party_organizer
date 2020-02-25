//
//  CRUDPartyCellBlueprint.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/24/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import UIKit

class CRUDPartyCellBlueprint {
    
    let member: Profile
    
    init(member: Profile) {
        self.member = member
    }
}

extension CRUDPartyCellBlueprint : CellBlueprint {
    
    var reusableIdentifier: String {
        return "CRUDPartyTableViewCell"
    }
    
    var selectable: Bool {
        return false
    }
    
    func configure(cell: Cell) -> Cell {
        let crudPartyCell = cell as! CRUDPartyTableViewCell
        crudPartyCell.configure(member: member)
        return crudPartyCell
    }
}
