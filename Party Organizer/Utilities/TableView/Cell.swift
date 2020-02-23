//
//  Cell.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/23/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//
import UIKit

protocol SelectableTableCell where Self : UITableViewCell {
    
    var isSelectable : Bool { get set }
}

protocol Cell : SelectableTableCell { }
