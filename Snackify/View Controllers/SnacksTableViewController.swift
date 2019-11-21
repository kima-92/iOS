//
//  SnacksTableViewController.swift
//  Snackify
//
//  Created by macbook on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class SnacksTableViewController: UITableViewController {
    
    var snackManager: SnackManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(red: 102, green: 236, blue: 135, alpha: 1)
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
            detailVC.snack = snack
            print("Going to snack detail for \(detailVC.snack?.name ?? "nil")")
        }
    }

}
