//
//  User.swift
//  Snackify
//
//  Created by Jon Bash on 2019-11-18.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: Int? = nil
    
    let username: String
    let password: String
    let email: String
    let phoneNumber: String
    let streetAddress: String
    let state: String
    let zipCode: String
    let orgId: Int
    let contactPerson: String
    let role: String
    
    // employee only
    let organizationName: String?
    
    // org only
    let fullName: String?
    let orgID: Int?
    var isAdmin: Bool?
}
