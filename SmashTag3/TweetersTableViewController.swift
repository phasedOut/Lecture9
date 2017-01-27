//
//  TweetersTableViewController.swift
//  SmashTag3
//
//  Created by Yuji Sakai on 1/25/17.
//  Copyright © 2017 Yuji Sakai. All rights reserved.
//

import UIKit
import CoreData


class TweetersTableViewController: CoreDataTableViewController {

    var mention: String? { didSet { updateUI() } }
    var managedObjectContext: NSManagedObjectContext? { didSet{ updateUI() } }


    private func updateUI() {
        if let context = managedObjectContext, mention != nil {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterUser")
            request.predicate = NSPredicate(format: "any tweets.text contains[c] %@ and !screenName beginswith[c] %@", mention!, "darkside")
            request.sortDescriptors = [NSSortDescriptor(
                key: "screenName",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
        } else {
            fetchedResultsController = nil
        }
    }
    // MARK: - Table view data source

    private func tweetCountMentionByTwitterUser(user: TwitterUser) -> Int? {
        var count: Int?
        user.managedObjectContext?.performAndWait {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tweets")
            request.predicate = NSPredicate(format: "text contains[c] %@ and tweeter = %@", self.mention!, user)
            do {
                count = try user.managedObjectContext?.count(for: request)
            } catch let error {
                print("Could not request NSFetchRequest, \(error)")
            }
        }
        return count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterUserCell", for: indexPath)
        
        if let twitterUser = fetchedResultsController?.object(at: indexPath) as? TwitterUser {
            var screenName: String?
            twitterUser.managedObjectContext?.performAndWait {
                screenName = twitterUser.screenName
            }
            cell.textLabel?.text = screenName
            if let count = tweetCountMentionByTwitterUser(user: twitterUser) {
                cell.detailTextLabel?.text = (count == 1) ? "1 tweet" : "\(count) tweets"
            } else {
                cell.detailTextLabel?.text = ""
            }
        }

        // Configure the cell...

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
