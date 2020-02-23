//
//  CellBluenprint.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/23/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

protocol CellBlueprint {
    
    var reusableIdentifier: String { get }
    var selectable : Bool { get }
    var selected: Bool { get set }
    func configure(cell: Cell) -> Cell
}

//MARK: Default implementation

extension CellBlueprint {
    
    var selected : Bool {
        
        get { return false }
        set { }
    }
    
    func configure(cell: Cell) -> Cell {
        return cell
    }
}
