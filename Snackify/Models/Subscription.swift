//
//  Subscription.swift
//  Snackify
//
//  Created by Jon Bash on 2019-11-18.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct Subscription: Codable {
    var name: String
    var monthlyFee: Double
    var lengthOfSubscription: DateInterval
    var snacks: [Snack]
}
