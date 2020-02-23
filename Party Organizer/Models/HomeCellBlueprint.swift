//
//  HomeCellBlueprint.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/23/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import UIKit

class HomeCellRowBlueprint {
    
    let party: Party
    
    init(party: Party) {
        self.party = party
    }
}

extension HomeCellRowBlueprint : CellBlueprint {
    
    var reusableIdentifier: String {
        return "homeTableViewCell"
    }
    
    var selectable: Bool {
        return false
    }
    
    func configure(cell: Cell) -> Cell {
        let homeCell = cell as! HomeTableViewCell
        homeCell.configure(party: party)
        return homeCell
    }
}
