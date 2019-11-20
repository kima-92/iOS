//
//  SnacksMainViewController.swift
//  Snackify
//
//  Created by macbook on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SnacksMainViewController: UIViewController {
    
    var networkManager = NetworkManager()
    var snackManager: SnackManager?
    
    //MARK: Outlets
    @IBOutlet weak var welcomeUserLabel: UILabel!
    @IBOutlet weak var nextOrderDeadlineLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // transition to login view if conditions require
        if networkManager.bearer == nil {
            performSegue(withIdentifier: "LoginModalSegue", sender: self)
        } else {
            snackManager = SnackManager(networkManager: networkManager)
        }
    }
    
    //MARK: Actions
    @IBAction func logOutButtonTapped(_ sender: UIBarButtonItem) {
        networkManager.logOut()
        performSegue(withIdentifier: "LoginModalSegue", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginModalSegue" {
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.networkManager = networkManager
            }
            return
        }
        if snackManager == nil {
            snackManager = SnackManager(networkManager: networkManager)
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
        }
    }
}
