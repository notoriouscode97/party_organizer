//
//  NibLoadable.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/23/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import UIKit

protocol NibLoadable {
    static var nibName: String { get }
    static var nib: UINib { get }
}

extension NibLoadable where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: Bundle(for: self))
    }
}
