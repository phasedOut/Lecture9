//
//  DetailTableViewController.swift
//  SmashTag3
//
//  Created by Yuji Sakai on 1/14/17.
//  Copyright © 2017 Yuji Sakai. All rights reserved.
//

import UIKit
import Twitter

class DetailTableViewController: UITableViewController {
    
//    var userMention: [Tweet.IndexedKeyword]?
//    var hashtags: [Tweet.IndexedKeyword]?
    
    var tweetCollection = [[String : Any]]()
    
    //var tweetMedia: [String: [MediaItem]]?
    
    var tweet: Tweet? {
        didSet{
            updateUI()
//            tweetCollection.append(["Hash Tags" : tweet?.hashtags ?? ""] as [String: Any])
//            tweetCollection.append(["Urls" : tweet?.hashtags ?? ""] as [String: Any])
//            tweetCollection.append(["Images" : tweet?.media ?? ""] as [String:Any])
//            tweetData?["hashTags"] = tweet?.hashtags
//            tweetData?["urls"] = tweet?.urls
//            tweetMedia?["images"] = tweet?.media
        }
    }
    
    private func updateUI() {
        if let tweet = self.tweet {
            if tweet.userMentions.description != "[]" {
                appendToCollection(object: ["User Mention(s)" : tweet.userMentions])
            }
            if tweet.hashtags.description != "[]" {
                appendToCollection(object: ["Hash Tag(s)" : tweet.hashtags])
            }
            if tweet.urls.description != "[]" {
                appendToCollection(object: ["Url(s)" : tweet.urls])
            }

        }
    }
    
    private func appendToCollection(object: [String : [Tweet.IndexedKeyword]] ){
        tweetCollection.append(object)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension

    }
    
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweetCollection.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetCollection[section].values.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = [tweetCollection[section].first?.key]
        return key[0]
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "detailMention", for: indexPath)
//        
//        if let data = cell as? DetailTableViewCell {
//            let hashtags = tweet?.hashtags
//            data.label.text = hashtags?.description
//        }

       // var x = tableView.indexPathForSelectedRow
        let data = tweetCollection[indexPath.section]
        
        let dequeued = tableView.dequeueReusableCell(withIdentifier: "detailMention", for: indexPath)
        
        if let cell = dequeued as? DetailTableViewCell {
            cell.label.text = data.description
        }
        // Configure the cell...
        return dequeued
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
