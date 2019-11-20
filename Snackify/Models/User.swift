//
//  User.swift
//  Snackify
//
//  Created by Jon Bash on 2019-11-18.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct User {
    let id: Int? = nil
    
    let username: String
    let password: String
    let fullName: String
    let email: String
    let phoneNumber: String
    let streetAddress: String
    let state: String
    let zipCode: String
    let orgId: Int = 1
    
    var isAdmin: Bool
    var isOrganization: Bool
    
    var representation: Representation {
        #warning("Currently returns temporary values for `contactPerson`")
        return Representation(username: username, password: password, fullName: fullName, email: email, phoneNumber: phoneNumber, streetAddress: streetAddress, state: state, zipcode: zipCode, orgId: orgId, contactPerson: "", role: isAdmin ? "orgAdmin" : "employee")
    }
    
    struct Representation: Codable {
        let username: String
        let password: String
        let fullName: String?
        let organizationName: String?
        let email: String
        let phoneNumber: String
        let streetAddress: String
        let state: String
        let zipcode: String
        let orgId: Int
        let contactPerson: String
        let role: String?
    }
}
