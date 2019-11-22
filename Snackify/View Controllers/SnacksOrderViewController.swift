//
//  SnacksOrderViewController.swift
//  Snackify
//
//  Created by macbook on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SnacksOrderViewController: UIViewController {
    
    // MARK: - Properties
    
    var snacks: [Snack]?
    var subsDeadline: String?
    var snackManager: SnackManager?
    
    lazy var submittedOrderAlert: UIAlertController = {
           let alert = UIAlertController(
               title: "Subscription Order has been submitted!",
               message: "Your order is set to arrive on 11/29/2019",
               preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Dismiss", style: .default) { (alertAction) in
               self.dismiss(animated: true, completion: nil)
           })
           return alert
       }()
    
    // MARK: Outlets
    
    @IBOutlet weak var amountOfSnacksLabel: UILabel!
    @IBOutlet weak var snacksListTextView: UITextView!
    @IBOutlet weak var priceTotalLabel: UILabel!
    @IBOutlet weak var subscriptionEndLabel: UILabel!
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard let snacks = snacks,
            let subsDeadline = subsDeadline else { return }
        
        let listOfSnacks = snacks.compactMap( { $0.name })

        priceTotalLabel.text = addSnacksTotal(snacks: snacks)
        subscriptionEndLabel.text = subsDeadline
        amountOfSnacksLabel.text = String(snacks.count)
        
        if listOfSnacks.count == 0 {
            snacksListTextView.text = ""
        } else {
            snacksListTextView.text = "*" + listOfSnacks.joined(separator: "\n*")
        }
    }
    
    // MARK: - Actions
    
    @IBAction func placeOrderButtonTapped(_ sender: UIButton) {
        present(submittedOrderAlert, animated: true)
    }
    
    // MARK: - Helper Methods
    
    func addSnacksTotal(snacks: [Snack]) -> String {
        let priceFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.currencySymbol = "$"
            formatter.numberStyle = .currency
            return formatter
        }()
        
        var totalDouble: Double = 0.0
        var totalString: String = ""
        
        for snack in snacks {
            totalDouble += snack.price
        }
        
        totalString = priceFormatter.string(from: NSNumber(value: totalDouble)) ?? ""
        return totalString
    }
}
