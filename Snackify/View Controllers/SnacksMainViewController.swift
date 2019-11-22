//
//  SnacksMainViewController.swift
//  Snackify
//
//  Created by macbook on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SnacksMainViewController: UIViewController {
    
    // MARK: - Properties
    
    var networkManager = NetworkManager()
    var snackManager: SnackManager?
    
    // MARK: Outlets
    
    @IBOutlet weak var welcomeUserLabel: UILabel!
    @IBOutlet weak var nextOrderDeadlineLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    
    // MARK: - View Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // transition to login view if conditions require
        if networkManager.bearer == nil {
            performSegue(withIdentifier: "LoginModalSegue", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateViews()
    }
    
    func updateViews() {
        welcomeUserLabel.text = "Welcome, \(networkManager.username ?? "user")!"
        nextOrderDeadlineLabel.text = snackManager?.subsOrderDeadline
        
        if let isAdmin = networkManager.userType?.isAdmin, isAdmin == true {
            subscribeButton.isHidden = false
        } else {
            subscribeButton.isHidden = true
        }
    }
    
    // MARK: - Actions
    
    @IBAction func logOutButtonTapped(_ sender: UIBarButtonItem) {
        networkManager.logOut()
//        snackManager = nil
        performSegue(withIdentifier: "LoginModalSegue", sender: self)
    }
    
    func showRequestAlertIfAdmin() {
        guard let isAdmin = networkManager.userType?.isAdmin,
            isAdmin,
            let noSnackRequests = snackManager?.snackRequests.isEmpty,
            !noSnackRequests
            else { return }
//        guard (networkManager.userType?.isAdmin ?? false) && !(snackManager?.snackRequests.isEmpty ?? true) else { return }
        let requestAlert: UIAlertController = {
            let alert = UIAlertController(
                title: "New subscription requests!",
                message: "Your employees have requested new subscription items. Add them to your subscription order?\n(You'll have time to review these before checkout.)",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Clear requests", style: .cancel) { (alertAction) in
                self.snackManager?.snackRequests = []
            })
            alert.addAction(UIAlertAction(title: "Add items to order", style: .default) { (alertAction) in
                guard let snackRequests = self.snackManager?.snackRequests else { return }
                for snack in snackRequests {
                    self.snackManager?.addSnackToCurrentSubscription(snack)
                }
            })
            return alert
        }()
        self.present(requestAlert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.networkManager = networkManager
                loginVC.delegate = self
            }
            return
        }
        if segue.identifier == "ShowAvailableSnacksSegue" {
            if let tableVC = segue.destination as? SnacksTableViewController {
                tableVC.snackManager = snackManager
                if snackManager?.allSnacksOptions == nil {
                    snackManager?.fetchSnackOptions(completion: { (result) in
                        do {
                            let _ = try result.get()
                            DispatchQueue.main.async {
                                tableVC.tableView.reloadData()
                            }
                        } catch {
                            NSLog((error as? NetworkError)?.rawValue ?? "")
                            return
                        }
                    })
                }
            }
        } else if segue.identifier == "SubscriptionOrderFromMain" {
            if let orderVC = segue.destination as? SnacksOrderViewController {
                orderVC.snackManager = snackManager
                orderVC.snacks = snackManager?.currentOrderSnacks
                orderVC.subsDeadline = snackManager?.subsOrderDeadline
            }
        }
    }
}
