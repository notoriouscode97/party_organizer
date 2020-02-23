//
//  PartyModel.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/23/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import Foundation

struct Party {
    let name: String
    let date: Date
    let description: String
    let members: [Profile]?
}
