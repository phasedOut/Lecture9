//
//  TweetTableViewController.swift
//  SmashTag2
//
//  Created by Yuji Sakai on 1/2/17.
//  Copyright © 2017 Yuji Sakai. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    var managedObjectContext: NSManagedObjectContext? =
    (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var tweets = [Array<Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchText: String? {
        didSet {
            tweets.removeAll()
            searchForTweets()
            title = searchText
        }
    }
    
    private var twitterRequest: TwitterRequest? {
        if let query = searchText, !query.isEmpty {
            return Twitter.TwitterRequest(search: query + " -filter:retweets", count: 100)
        }
        return nil
    }
    
    private var lastTwitterRequest: TwitterRequest?
    
    private func searchForTweets() {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets { [weak weakSelf = self] newTweets in
                DispatchQueue.main.async {
                    if request === weakSelf?.lastTwitterRequest  {
                        if !newTweets.isEmpty {
                            weakSelf?.tweets.insert(newTweets, at: 0)
                        }
                    }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - UITable view data source
    
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
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TweetCellIdentifier, for: indexPath)
        
        let tweet = tweets[indexPath.section][indexPath.row]
        
        //because this is a custom cell...
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        return cell
    }
    
    @IBOutlet weak var searchTextfield: UITextField! {
        didSet{
            searchTextfield.delegate = self
            searchTextfield.text = searchText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let vc = segue.destination as? DetailTableViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    let tweetInfo = tweets[indexPath.section][indexPath.row]
                    vc.tweet = tweetInfo
                }
                
            }
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
