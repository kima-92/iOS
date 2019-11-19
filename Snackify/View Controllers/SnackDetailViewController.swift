//
//  SnackDetailViewController.swift
//  Snackify
//
//  Created by macbook on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SnackDetailViewController: UIViewController {
    
    var  snack: Snack?
    
    //MARK: Outlets
    @IBOutlet weak var snackNameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalWeightLabel: UILabel!
    
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var totalFatLabel: UILabel!
    @IBOutlet weak var totalSugarLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var allergensLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    func updateViews() {
        
        guard let snack = snack else { return }
        
        var allergens = snack.nutritionInfo.allergens.compactMap({ $0.rawValue })
        
        snackNameLabel.text = snack.name
        typeLabel.text = snack.type
        servingsLabel.text = String(snack.numberOfServings)
        priceLabel.text = String(snack.price)
        totalWeightLabel.text = String(snack.totalWeight)
        
        caloriesLabel.text = String(snack.nutritionInfo.calories)
        totalFatLabel.text = String(snack.nutritionInfo.totalFat)
        totalSugarLabel.text = String(snack.nutritionInfo.totalSugars)
        proteinLabel.text = String(snack.nutritionInfo.protein)
        carbsLabel.text = String(snack.nutritionInfo.carbs)
        allergensLabel.text = allergens.joined(separator: ", ")
    }
}
