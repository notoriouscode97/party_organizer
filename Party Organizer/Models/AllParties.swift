//
//  AllParties.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/23/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import Foundation
import RxSwift

struct Parties {
   static var allParties: BehaviorSubject<[Party]> = BehaviorSubject(value: [])
    static var membersToAddForCreate: BehaviorSubject<[Profile]> = BehaviorSubject(value: [])
}

