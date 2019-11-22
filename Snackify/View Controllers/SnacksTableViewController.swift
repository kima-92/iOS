//
//  SnacksTableViewController.swift
//  Snackify
//
//  Created by macbook on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SnacksTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var snackManager: SnackManager?
    
    @IBOutlet var checkoutButton: UIBarButtonItem!
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let isAdmin = snackManager?.networkManager.userType?.isAdmin, isAdmin {
            checkoutButton.isEnabled = true
            navigationItem.rightBarButtonItem = checkoutButton
        } else {
            checkoutButton.isEnabled = false
            navigationItem.rightBarButtonItem = nil
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let snacks = snackManager?.allSnacksOptions else {
            return 0
        }
        return snacks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SnackCell", for: indexPath)

        guard let snack = snackManager?.allSnacksOptions?[indexPath.row]
            else { return cell }
        cell.textLabel?.text = snack.name

        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSnackDetailSegue" {
            guard let detailVC = segue.destination as? SnackDetailViewController,
                let selectedRow = tableView.indexPathForSelectedRow?.row,
                let snack = snackManager?.allSnacksOptions?[selectedRow]
                else { return }
            snackManager?.getSnackNutritionInfo(for: snack, completion: { (result) in
                DispatchQueue.main.async {
                    if detailVC.isViewLoaded {
                        detailVC.updateViews()
                    }
                }
            })
            detailVC.snackManager = snackManager
            detailVC.snack = snack
        }
        else if segue.identifier == "PlaceOrderFromTableVCSegue" {
            guard let orderVC = segue.destination as? SnacksOrderViewController else { return }
            
            orderVC.snackManager = snackManager
            orderVC.snacks = snackManager?.currentOrderSnacks
            orderVC.subsDeadline = snackManager?.subsOrderDeadline
        }
    }
}
