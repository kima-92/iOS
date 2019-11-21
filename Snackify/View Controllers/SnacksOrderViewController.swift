//
//  SnacksOrderViewController.swift
//  Snackify
//
//  Created by macbook on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SnacksOrderViewController: UIViewController {
    
    var snacks: [Snack]?
    
    
    //MARK: Outlets
    
    @IBOutlet weak var amountOfSnacksLabel: UILabel!
    @IBOutlet weak var snacksListLabel: UILabel!
    @IBOutlet weak var priceTotalLabel: UILabel!
    @IBOutlet weak var subscriptionEndLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    //MARK: Actions
    @IBAction func placeOrderButtonTapped(_ sender: UIButton) {
    }
    
    func updateViews() {
        
//        guard let snacks = snacks else { return }
//        
//        priceTotalLabel.text = addSnacksTotal(snacks: snacks)
//        subscriptionEndLabel.text =
    }
    
    
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
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
