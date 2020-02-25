//
//  PartyModel.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/23/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import Foundation

struct Party {
    var id: Int
    var name: String
    var date: Date
    var description: String
    var members: [Profile] = []
}
