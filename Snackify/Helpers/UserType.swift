//
//  UserType.swift
//  Snackify
//
//  Created by Jon Bash on 2019-11-20.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

enum UserType {
    case employee
    case orgAdmin
    case organization
    
    var isAdmin: Bool {
        switch self {
        case .employee:
            return false
        case .orgAdmin, .organization:
            return true
        }
    }
}
