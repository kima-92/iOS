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
    
    @IBOutlet weak var cartTableView: UITableView!
    
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
    @IBOutlet weak var priceTotalLabel: UILabel!
    @IBOutlet weak var subscriptionEndLabel: UILabel!
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        snacks = snackManager?.currentOrderSnacks
        guard let snacks = snacks,
            let subsDeadline = subsDeadline else { return }

        priceTotalLabel.text = addSnacksTotal(snacks: snacks)
        subscriptionEndLabel.text = subsDeadline
        amountOfSnacksLabel.text = String(snacks.count)
        
        cartTableView.reloadData()
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

// MARK: - Table View Data Source

extension SnacksOrderViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snackManager?.currentOrderSnacks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath)
        guard let snack = snackManager?.currentOrderSnacks[indexPath.row] else { return cell }
        
        cell.textLabel?.text = snack.name
        cell.detailTextLabel?.text = snack.priceText
        
        return cell
    }
    
    // remove snack from cart
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            snackManager?.currentOrderSnacks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateViews()
        }
    }
    
    // prevent selection of rows
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
