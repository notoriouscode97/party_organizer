//
//  Datasource.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/23/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import UIKit

class DataSource : ArrayDataSource<[CellBlueprint]> {
    
    init() {
        super.init() { (tableView, i, cellBlueprint) in
            let tableViewCell = tableView.dequeueReusableCell(withIdentifier: cellBlueprint.reusableIdentifier)
            guard let cell = tableViewCell as? Cell else { return tableViewCell! }
            
            cell.isSelectable = cellBlueprint.selectable
            return cellBlueprint.configure(cell: cell) as UITableViewCell
        }
    }
}
