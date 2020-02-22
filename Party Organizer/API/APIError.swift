//
//  APIError.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/22/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import Foundation

enum APIError: Error {
    case serverError
}

extension APIError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .serverError:
            return NSLocalizedString("Server error.", comment: "Server error")
        }
    }
}
