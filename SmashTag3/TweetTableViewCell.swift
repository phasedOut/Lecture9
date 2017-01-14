//
//  TweetTableViewCell.swift
//  SmashTag3
//
//  Created by Yuji Sakai on 1/12/17.
//  Copyright © 2017 Yuji Sakai. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetProfileImageView: UIImageView!
    
    @IBOutlet weak var tweetCreatedLabel: UILabel!

    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        tweetScreenNameLabel?.text = nil
        tweetTextLabel?.text = nil
        
        //load new information from our tweet (if any)
        
        if let tweet = self.tweet {
            if let profileImageUrl = tweet.user.profileImageURL {
                DispatchQueue.global().async{
                    if let imageData = NSData(contentsOf: profileImageUrl as URL) { //blocks main thread!
                        DispatchQueue.main.async {
                            self.tweetProfileImageView?.image = UIImage(data: imageData as Data)
                        }
                    }
                }
            }
        }

        let formatter = DateFormatter()
        if NSDate().timeIntervalSince(tweet?.created as! Date) > 24*60*60 {
            formatter.dateStyle = .short
        } else {
            formatter.timeStyle = .short
        }
        tweetCreatedLabel?.text = formatter.string(from: tweet?.created as! Date)
        
        tweetScreenNameLabel?.text = "\(tweet!.user!)"
        
        
        //Text highlights
        var tempText = NSMutableAttributedString(string: (tweet?.text)!)
        let yellowHighlight = [NSBackgroundColorAttributeName : UIColor.yellow]
        let lightGrayHighlight = [NSBackgroundColorAttributeName : UIColor.lightGray]
        let blueHighlight = [NSForegroundColorAttributeName : UIColor.blue]

        tempText = attributeIt(string: tweet?.hashtags, temp: tempText, attr: yellowHighlight)
        tempText = attributeIt(string: tweet?.userMentions, temp: tempText, attr: lightGrayHighlight)
        tempText = attributeIt(string: tweet?.urls, temp: tempText, attr: blueHighlight)

        tweetTextLabel?.attributedText = tempText
        

        //add camera emoji
        if tweetTextLabel?.text != nil {
            for _ in tweet!.media {
                tweetTextLabel.text! += " 📸"
            }
        }
        
        
    }
    private func attributeIt(string: [Tweet.IndexedKeyword]?, temp: NSMutableAttributedString, attr: [String : UIColor]) -> NSMutableAttributedString {
        if let range = string {
            for i in range {
                let myRange = NSRange(location: i.nsrange.location, length: i.nsrange.length)
                temp.addAttributes(attr, range: myRange)
            }
        }
        return temp
    }
}
