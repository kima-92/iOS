//
//  Subscription.swift
//  Snackify
//
//  Created by Jon Bash on 2019-11-18.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

// Currently unused
struct Subscription: Codable {
    
    let id: Int
    let orgId: Int
    let nameOfSubscription: String
    let monthlyFee: Double
    let lengthOfSubscription: DateInterval // Date()  ?
    var snacks: [Snack.Representation]?
    
    var representation: Representation?
    
    struct Representation: Codable {
        let id: Int
        let orgId: Int
        let nameOfSubscription: String
        let monthlyFee: Double
        let lengthOfSubscription: DateInterval // Date()  ?
    }
    
    init(fromRepresentation rep: Representation) {
        self.id = rep.id
        self.orgId = rep.orgId
        self.nameOfSubscription = rep.nameOfSubscription
        self.monthlyFee = rep.monthlyFee
        self.lengthOfSubscription = rep.lengthOfSubscription
    }
}
