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
            request.predicate = NSPredicate(format: <#T##String#>, <#T##args: CVarArg...##CVarArg#>)
        }
    }


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
}
