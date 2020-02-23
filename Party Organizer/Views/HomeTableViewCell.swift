//
//  HomeTableViewCell.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/23/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        selectionStyle = .none
    }
    
    func configure(party: Party) {
        nameLabel.text = party.name
        dateLabel.text = "\(party.date)"
        descriptionLabel.text = party.description
    }
}

//MARK: Cell

extension HomeTableViewCell : Cell {
    
    var isSelectable: Bool {
        get { return false }
        set { }
    }
}
