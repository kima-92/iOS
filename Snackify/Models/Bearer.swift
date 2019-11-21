//
//  Bearer.swift
//  Snackify
//
//  Created by Jon Bash on 2019-11-18.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    let message: String
    let orgID: String?
    let role: String
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case message
        case orgID = "OrgId"
        case role = "Role"
        case token
    }
}
