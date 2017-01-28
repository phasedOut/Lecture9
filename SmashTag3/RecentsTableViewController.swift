//
//  RecentsTableViewController.swift
//  SmashTag3
//
//  Created by Yuji Sakai on 1/22/17.
//  Copyright © 2017 Yuji Sakai. All rights reserved.
//

import UIKit
import CoreData
import Twitter


class RecentsTableViewController: UITableViewController {
    
    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext
    
    var selectedRecentTweet: String?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }

    @IBAction func clearTapped(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Warning", message: "Are you sure you want to delete your search history?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Confirm", style: .destructive) { (action) in
            SearchHistory.History.clear()
            self.tableView.reloadData()
        })

        self.present(alertController, animated: true, completion: nil)
        
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return SearchHistory.History.history.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "history", for: indexPath)
        
        let data = SearchHistory.History.history[indexPath.row]
        
        cell.textLabel?.text = data
        
        cell.accessoryType = UITableViewCellAccessoryType.detailDisclosureButton

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "showUserAndHashtag", sender: UITableViewCellAccessoryType.detailDisclosureButton)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            SearchHistory.History.delete(index: indexPath.row)
            tableView.reloadData()
        }
    }
    
    struct Storyboard {
        static var unwind = "unwind"
        static var showUserAndHashtag = "showUserAndHashtag"
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.unwind:
                if let cell = sender as? UITableViewCell {
                    let indexPath = tableView.indexPath(for: cell)
                    selectedRecentTweet = SearchHistory.History.history[(indexPath?.row)!]
                    
                }
            case Storyboard.showUserAndHashtag:
                print("hello0")
                if let AllUserHashTagsTVC = segue.destination as? AllUserHashTagsTableViewController {
                    let cell = sender as? UITableViewCell
                    AllUserHashTagsTVC.mention = cell?.textLabel?.text
                    AllUserHashTagsTVC.managedObjectContext = self.managedObjectContext
                }
            default:
                break
            }
        }
        
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
    


}
