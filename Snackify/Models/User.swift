//
//  User.swift
//  Snackify
//
//  Created by Jon Bash on 2019-11-18.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class User: Codable {
    // MARK: - Properties
    
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
    
    init(firstName: String, lastName: String, username: String, email: String, phoneNumber: String, streetAddress: String, state: String, zipCode: String, organization: Organization) {
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.email = email
        self.phoneNumber = phoneNumber
        self.streetAddress = streetAddress
        self.state = state
        self.zipCode = zipCode
        self.organization = organization
    }
}
