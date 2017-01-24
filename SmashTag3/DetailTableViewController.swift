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
    
    private var tweetCollection = [[Any]]()
    
    private var header = [String]()
    
    var selectedIndexedKeyword: String?
    
    var tweet: Tweet? {
        didSet{
            organize()
        }
    }
    
    private func organize() {
        if let tweet = self.tweet {

            if !tweet.userMentions.isEmpty {
                tweetCollection.append(tweet.userMentions)
                header.append("User Mentions")
            }
            if !tweet.hashtags.isEmpty {
                tweetCollection.append(tweet.hashtags)
                header.append("Hash Tags")
            }
            if !tweet.urls.isEmpty {
                tweetCollection.append(tweet.urls)
                header.append("Urls")
            }
            if !tweet.media.isEmpty {
                tweetCollection.append(tweet.media)
                header.append("Images")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorColor = UIColor.black.withAlphaComponent(0)
        tableView.estimatedRowHeight = tableView.rowHeight
        
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = tweetCollection[indexPath.section][indexPath.row]
        if data is MediaItem {
            return tableView.estimatedRowHeight
        }
        else {
            return UITableViewAutomaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let data = tweetCollection[indexPath.section][indexPath.row]
        
        var dequeued = UITableViewCell()
        
        //show label
        if data is Tweet.IndexedKeyword {
            dequeued = tableView.dequeueReusableCell(withIdentifier: "detailMention", for: indexPath)
            
            if let indexedKeyword = data as? Tweet.IndexedKeyword {
                let text = indexedKeyword.keyword
                
                if let cell = dequeued as? DetailTableViewCell {
                    cell.label.text = text
                }
            }
        }
        //show image
        else if data is MediaItem {
            dequeued = tableView.dequeueReusableCell(withIdentifier: "imageMention", for: indexPath)
            let media = data as! MediaItem
            if let cell = dequeued as? ImageTableViewCell {
                DispatchQueue.global().async {
                    if let imgData = NSData(contentsOf: media.url as URL) {
                        DispatchQueue.main.async {
                                cell.mentionedImage.image = UIImage(data: imgData as Data)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var cell: UITableViewCell?
            if let detail = sender as? DetailTableViewCell {
                cell = detail
            } else if let image = sender as? ImageTableViewCell {
                cell = image
            }

        if cell != nil {
            let indexPath = tableView.indexPath(for: cell!)
            let data = tweetCollection[(indexPath?.section)!][(indexPath?.row)!]
            if let index = data as? Tweet.IndexedKeyword {
                selectedIndexedKeyword = index.keyword
            }
            
            struct Storyboard {
                static let showImage = "showImage"
                static let unwind = "unwind"
            }
            if let identifier = segue.identifier {
                switch identifier {
                case Storyboard.showImage:
                    
                    if data is MediaItem  {
                        let ivc = segue.destination as? ImageViewController
                        let url = data as! MediaItem
                        ivc?.imageURL = url.url
                    }
                    
                case Storyboard.unwind:
                    if let index = data as? Tweet.IndexedKeyword {
                        if index.keyword.range(of: "https") == nil {
                            performSegue(withIdentifier: "unwind", sender: self)
                        } else {
                            UIApplication.shared.open(URL(string: selectedIndexedKeyword!)!)
                        }
                    }
                default: break
                    
                }
            }
        }
    }
}
