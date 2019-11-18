//
//  Organization.swift
//  Snackify
//
//  Created by Jon Bash on 2019-11-18.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class Organization: Codable {
    let name: String
    let contactPerson: User
    
    init(name: String, contactPerson: User) {
        self.name = name
        self.contactPerson = contactPerson
    }
}
