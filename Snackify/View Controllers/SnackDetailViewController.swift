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
    
    lazy var priceFormatter: NumberFormatter = {
        var formatter = NumberFormatter()
        formatter.currencySymbol = "$"
        formatter.numberStyle = .currency
        return formatter
    }()
    
    lazy var priceText: String = {
        return self.priceFormatter.string(from: NSNumber(value: snack?.price ?? 0.0)) ?? ""
    }()
    
    // MARK: - Purchase Alerts
    
    lazy var confirmPurchaseAlert: UIAlertController = {
        var alert = UIAlertController(
            title: "Purchase \(snack!.name)?",
            message: "Are you sure you'd like to make a one time-purchase of \(snack!.name) for \(priceText)?",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "Confirm", style: .default) { (alertAction) in
            self.present(self.madePurchaseAlert, animated: true, completion: nil)
        })
            
        return alert
    }()
    
    lazy var madePurchaseAlert: UIAlertController = {
        let alert = UIAlertController(
            title: "\(snack!.name) purchased!",
            message: "Your snack will be delivered with the next regular subscription delivery.",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (alertAction) in
            self.dismiss(animated: true, completion: nil)
        })
        return alert
    }()
    
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
        present(confirmPurchaseAlert, animated: true, completion: nil)
    }
    
    @IBAction func subscriptionAddTapped(_ sender: UIButton) {
    }
    
    func updateViews() {
        guard let snack = snack,
            let nutriInfo = snack.nutritionInfo
            else { return }
        
        snackNameLabel.text = snack.name
        typeLabel.text = snack.type
        servingsLabel.text = String(snack.numberOfServings)
        priceLabel.text = priceText
        totalWeightLabel.text = String(snack.totalWeight)
        
        caloriesLabel.text = String(nutriInfo.calories ?? 0)
        totalFatLabel.text = String(nutriInfo.totalFat ?? 0)
        totalSugarLabel.text = String(nutriInfo.totalSugars ?? 0)
        proteinLabel.text = String(nutriInfo.protein ?? 0)
        carbsLabel.text = String(nutriInfo.carbs ?? 0)
        allergensLabel.text = String(nutriInfo.allergens ?? "")
    }
}
