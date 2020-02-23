//
//  NibReusable.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/23/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import UIKit

protocol NibReusable: Reusable, NibLoadable {
}

extension UIView: NibLoadable {
}
