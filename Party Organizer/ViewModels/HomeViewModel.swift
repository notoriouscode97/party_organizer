//
//  HomeViewModel.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/23/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import RxSwift

class HomeViewModel {
    let bag = DisposeBag()
    
    var parties: BehaviorSubject = BehaviorSubject(value: [])
    
    init() {
        APIClient.shared.getMembers()
    }
}
