//
//  Snack.swift
//  Snackify
//
//  Created by Jon Bash on 2019-11-18.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class Snack {
    
    // MARK: - Properties
    let id: Int
    let name: String
    let type: String = "" // unused
    let numberOfServings: Int
    var nutritionInfo: NutritionInfo? = nil // fetched when needed
    let totalWeight: Double
    let price: Double
    
    // MARK: Price Formatting
    
    private lazy var priceFormatter: NumberFormatter = {
        var formatter = NumberFormatter()
        formatter.currencySymbol = "$"
        formatter.numberStyle = .currency
        return formatter
    }()
    
    var priceText: String {
        return priceFormatter.string(from: NSNumber(value: price )) ?? "$0.00"
    }
    
    // MARK: - Representation
    
    var representation: Representation?
    
    struct Representation: Codable {
        let id: Int
        let name: String
        let numberOfServings: Int
        let totalWeight: Double
        let price: Double
        let subId: Int
    }
    
    init(fromRepresentation rep: Representation) {
        self.id = rep.id
        self.name = rep.name
        self.numberOfServings = rep.numberOfServings
        self.totalWeight = rep.totalWeight
        self.price = rep.price
    }
}

// MARK: - Nutrition Info

struct NutritionInfo: Codable {
    let snackId: Int
    let calories: Double?
    let totalFat: Double?
    let totalSugars: Double?
    let protein: Double?
    let carbs: Double?
    let allergens: String?
}
