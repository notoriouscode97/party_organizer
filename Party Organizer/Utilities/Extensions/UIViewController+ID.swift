//
//  UIViewController+ID.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/23/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import UIKit

extension UIViewController {

    static var ID: String {
        return String(describing: self)
    }

}

extension UITableViewCell {
    static var ID: String {
        return String(describing: self)
    }
}
