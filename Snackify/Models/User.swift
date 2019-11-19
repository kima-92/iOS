//
//  User.swift
//  Snackify
//
//  Created by Jon Bash on 2019-11-18.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let username: String
    let email: String
    let phoneNumber: String
    let streetAddress: String
    // let streetAddress2: String
    let state: String
    let zipCode: String
    let organization: Organization
    var isAdmin: Bool
}
