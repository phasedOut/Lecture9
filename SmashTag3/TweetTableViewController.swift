//
//  TweetTableViewController.swift
//  SmashTag3
//
//  Created by Yuji Sakai on 1/12/17.
//  Copyright © 2017 Yuji Sakai. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext
    
    var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchText: String? {
        didSet{
            tweets.removeAll()
            searchForTweets()
            title = searchText
        }
    }
    
    private var twitterRequest: TwitterRequest? {
        if let query = searchText, !query.isEmpty{
            return TwitterRequest(search: query + " -filter:retweets", count: 100)
        }
        return nil
    }
    
    private var lastTwitterRequest: TwitterRequest?
    
    private func searchForTweets() {
        if let request =  twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets{ [weak weakSelf = self] newTweets in
                DispatchQueue.main.async{
                    if request === weakSelf?.lastTwitterRequest {
                        if !newTweets.isEmpty {
                           weakSelf?.tweets.insert(newTweets, at: 0)
                            weakSelf?.updateDatabase(newTweets: newTweets)
                        }
                    }
                }
            }
        }
    }
    
    private func updateDatabase(newTweets: [Tweet]) {
        managedObjectContext?.perform {
            for twitterInfo in newTweets {
                //create a new but unique Tweets with that Twitter info
                _ = Tweets.tweetWithTwitterInfo(twitterInfo: twitterInfo, inManagedObjectContext: self.managedObjectContext!)
            }
            do {
                try self.managedObjectContext?.save()
            } catch let error {
                print("Could not save, \(error)")
            }
        }
        printDataStatistics()
        print("Done printing database statistics")
    }
    
    private func printDataStatistics() {
        managedObjectContext?.perform {
            if let results = try? self.managedObjectContext?.fetch(NSFetchRequest(entityName: "TwitterUser")) {
                print("\(results!.count) Twitter Users")
            }
            let tweetCount = try? self.managedObjectContext?.count(for: NSFetchRequest(entityName: "Tweets"))
            print("\(tweetCount!) Tweets")
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
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }
    
    private struct Storyboard {
        static let TweetCellIdentifier = "Tweet"
        static let ShowDetail = "ShowDetail"
        static let TweetsMentioningSearchTerm = "TweetsMentioningSearchTerm"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TweetCellIdentifier, for: indexPath)
        
        let tweet = tweets[indexPath.section][indexPath.row]
        
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        return cell
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.frame.size.height = 50
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = searchTextField.text
        
        SearchHistory.History.append(string: searchText!)
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
                case Storyboard.ShowDetail:
                    if let cell = sender as? TweetTableViewCell {
                        let indexPath = tableView.indexPath(for: cell)
                        let seguedToMVC = segue.destination as? DetailTableViewController
                        seguedToMVC?.tweet = self.tweets[(indexPath?.section)!][(indexPath?.row)!]
                }
            case Storyboard.TweetsMentioningSearchTerm:
                if let tweetersTVC = segue.destination as? TweetersTableViewController {
                    tweetersTVC.mention = searchText
                    tweetersTVC.managedObjectContext = self.managedObjectContext
                }
                default:
                    break
            }
        }
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        if let detailTableVC = segue.source as? DetailTableViewController{
            searchText = detailTableVC.selectedIndexedKeyword
        }
        else if let recentTableVC = segue.source as? RecentsTableViewController{
            searchText = recentTableVC.selectedRecentTweet
        }
        searchTextField.text?.removeAll()
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
