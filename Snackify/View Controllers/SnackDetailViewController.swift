//
//  SnackDetailViewController.swift
//  Snackify
//
//  Created by macbook on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SnackDetailViewController: UIViewController {
    
    var snack: Snack?
    
    //MARK: - Outlets
    
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
    
    @IBOutlet weak var subscriptionAddButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    // MARK: - Actions
    
    @IBAction func buyNowTapped(_ sender: UIButton) {
    }
    
    @IBAction func subscriptionAddTapped(_ sender: UIButton) {
    }
    
    func updateViews() {
        guard let snack = snack,
            let nutriInfo = snack.nutritionInfo
            else { return }
        
//        var allergens = snack.nutritionInfo.allergens.compactMap({ $0.rawValue })
        
        snackNameLabel.text = snack.name
        typeLabel.text = snack.type
        servingsLabel.text = String(snack.numberOfServings)
        priceLabel.text = String(snack.price)
        totalWeightLabel.text = String(snack.totalWeight)
        
        caloriesLabel.text = String(nutriInfo.calories ?? 0)
        totalFatLabel.text = String(nutriInfo.totalFat ?? 0)
        totalSugarLabel.text = String(nutriInfo.totalSugars ?? 0)
        proteinLabel.text = String(nutriInfo.protein ?? 0)
        carbsLabel.text = String(nutriInfo.carbs ?? 0)
        allergensLabel.text = String(nutriInfo.allergens ?? "")
    }
}
