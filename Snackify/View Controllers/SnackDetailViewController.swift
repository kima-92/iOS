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
    var snackManager: SnackManager?
    
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
    
    lazy var addToSubscriptionAlert: UIAlertController = {
        let titleText: String
        let alertText: String
        let confirmActionText: String
        if let isAdmin = snackManager?.networkManager.userType?.isAdmin, isAdmin {
            titleText = "Add \(snack!.name) subscription?"
            alertText = "Are you sure you'd like to subscribe to \(snack!.name) for \(priceText)?\n(You will be able to review your order before checkout.)"
            confirmActionText = "Add to subscription"
        } else {
            titleText = "Request \(snack!.name) subscription?"
            alertText = "Are you sure you'd like to request that \(snack!.name) be added to your organization's snack subscription?"
            confirmActionText = "Request subscription"
        }
        
        var alert = UIAlertController(title: titleText, message: alertText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: confirmActionText, style: .default) { (alertAction) in
            if let isAdmin = self.snackManager?.networkManager.userType?.isAdmin, isAdmin {
                self.snackManager?.AddSnackToCurrentSubscription(snack: self.snack!)
            }
            self.dismiss(animated: true, completion: nil)
        })
            
        return alert
    }()
    
    //MARK: - Outlets
    
    @IBOutlet weak var snackNameLabel: UILabel!
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
    
    @IBOutlet var checkoutButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let subscribeButtonText: String
        if let isAdmin = snackManager?.networkManager.userType?.isAdmin, isAdmin {
            subscribeButtonText = "Add to Subscription"
            navigationItem.rightBarButtonItem = checkoutButton
        } else {
            subscribeButtonText = "Request Subscription"
            checkoutButton.isEnabled = false
            navigationItem.rightBarButtonItem = nil
        }
        subscriptionAddButton.setTitle(subscribeButtonText, for: .normal)
        updateViews()
    }
    
    // MARK: - Actions
    
    @IBAction func buyNowTapped(_ sender: UIButton) {
        present(confirmPurchaseAlert, animated: true, completion: nil)
    }
    
    @IBAction func subscriptionAddTapped(_ sender: UIButton) {
        present(addToSubscriptionAlert, animated: true, completion: nil)
    }
    
    @IBAction func cartButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    func updateViews() {
        guard let snack = snack else { return }
        
        snackNameLabel.text = snack.name
        servingsLabel.text = String(snack.numberOfServings)
        priceLabel.text = priceText
        totalWeightLabel.text = String(snack.totalWeight)
        
        guard let nutriInfo = snack.nutritionInfo else { return }
        
        caloriesLabel.text = String(nutriInfo.calories ?? 0)
        totalFatLabel.text = String(nutriInfo.totalFat ?? 0)
        totalSugarLabel.text = String(nutriInfo.totalSugars ?? 0)
        proteinLabel.text = String(nutriInfo.protein ?? 0)
        carbsLabel.text = String(nutriInfo.carbs ?? 0)
        allergensLabel.text = String(nutriInfo.allergens ?? "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlaceOrderFromDetailVCSegue" {
            guard let orderVC = segue.destination as? SnacksOrderViewController,
                let snacks = snackManager?.currentOrderSnacks
                else { return }
            
            orderVC.snackManager = snackManager
            orderVC.snacks = snacks
        }
    }
}
