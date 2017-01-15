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
    
    var tweetCollection = [[Any]]()
    
    private var header = [String]()
    
    var selectedIndexedKeyword: String?
    
    //var tweetMedia: [String: [MediaItem]]?
    
    var tweet: Tweet? {
        didSet{
            updateUI()
        }
    }
    
    private func updateUI() {
        if let tweet = self.tweet {

            if !tweet.userMentions.isEmpty {
                tweetCollection.append(tweet.userMentions)
                header.append("User Mention(s)")
            }
            if !tweet.hashtags.isEmpty {
                tweetCollection.append(tweet.hashtags)
                header.append("Hash Tag(s)")
            }
            if !tweet.urls.isEmpty {
                tweetCollection.append(tweet.urls)
                header.append("Url(s)")
            }
            if !tweet.media.isEmpty {
                tweetCollection.append(tweet.media)
                header.append("Image(s)")
            }
        }
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

        return tweetCollection[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return header[section]
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let data = tweetCollection[indexPath.section][indexPath.row]
        
        let dequeued = tableView.dequeueReusableCell(withIdentifier: "detailMention", for: indexPath)
        

        if let indexedKeyword = data as? Tweet.IndexedKeyword {
            let text = indexedKeyword.keyword
            
            if let cell = dequeued as? DetailTableViewCell {
                cell.label.text = text
            }
        }
        
        else if let media = data as? MediaItem {
            if let cell = dequeued as? DetailTableViewCell {
                cell.label.isHidden = true
                DispatchQueue.global().async {
                    if let imgData = NSData(contentsOf: media.url as URL) {
                        DispatchQueue.main.async {
                                cell.mentionImage.image = UIImage(data: imgData as Data)
                                UIView.performWithoutAnimation {
                                    tableView.beginUpdates()
                                    tableView.endUpdates()
                                }
                        }
                    }
                }
            }
            
        }
        
        return dequeued
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = tweetCollection[indexPath.section][indexPath.row]
        
        if let indexedKeyword = data as? Tweet.IndexedKeyword {
            selectedIndexedKeyword = indexedKeyword.keyword
        }
        
        
        performSegue(withIdentifier: "unwindToTweetTableViewController", sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let identifier = segue.identifier {
//            switch identifier {
//                case "showTweet":
//                    if let cell = sender as? DetailTableViewCell {
//                        let indexPath = tableView.indexPath(for: cell)
//                        let segueToVC = segue.destination as? TweetTableViewController
//                        if let text = self.tweetCollection[(indexPath?.section)!][(indexPath?.row)!] as? Tweet.IndexedKeyword {
//                            segueToVC?.searchText = text.keyword
//                        }
//                }
//            default: break
//            }
//        }
//    }


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
