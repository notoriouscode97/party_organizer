//
//  ViewLoadable.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/23/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

protocol ViewLoadable: NibLoadable {
    static var instance: Self { get }
}

extension ViewLoadable {
    static var instance: Self {
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? Self else {
            fatalError("Failed to create an instance of \(self) from \(self.nibName) nib.")
        }
        return view
    }
}
