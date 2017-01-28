//
//  AllUserHashTagsTableViewController.swift
//  SmashTag3
//
//  Created by Yuji Sakai on 1/28/17.
//  Copyright © 2017 Yuji Sakai. All rights reserved.
//

import UIKit
import CoreData

class AllUserHashTagsTableViewController: CoreDataTableViewController {
    
    

    var mention: String? {didSet{ updateUI() } }
    var managedObjectContext: NSManagedObjectContext? {didSet{ updateUI() } }
    
    private func updateUI() {
        if let context = managedObjectContext, mention != nil {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TwitterUser")
            request.predicate = NSPredicate(format: "any tweets.text contains[c] %@", mention!)
            request.sortDescriptors = [NSSortDescriptor(key: "screenName", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            print("hello1")
        } else {
            fetchedResultsController = nil
            print("hello2")

        }
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        if let twitterUser = fetchedResultsController?.object(at: indexPath) as? TwitterUser {
            var screenName: String?
            twitterUser.managedObjectContext?.performAndWait {
                screenName = twitterUser.screenName
            }
            cell.textLabel?.text = screenName
        }

        // Configure the cell...
                print("updating")

        return cell
    }
    
}
