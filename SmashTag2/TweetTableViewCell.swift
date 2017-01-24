//
//  TweetTableViewCell.swift
//  SmashTag2
//
//  Created by Yuji Sakai on 1/7/17.
//  Copyright © 2017 Yuji Sakai. All rights reserved.
//

import UIKit
import Twitter


class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        //reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetCreatedLabel?.text = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        
        //load new information from our tweet (if any)
        if let tweet = self.tweet {
            
            let nsText: NSString = tweet.text as NSString
            
            let words = nsText.components(separatedBy: " ")
                        
            let attrString = NSMutableAttributedString(string: nsText as String)
            
            for word in words {
                
                if word.hasPrefix("@") {
                    
                    let matchRange: NSRange = nsText.range(of: word)
                    
                    attrString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellow, range: matchRange)
                }
                
                if word.hasPrefix("#") {
                    
                    let matchRange: NSRange = nsText.range(of: word)
                    
                    let digits = NSCharacterSet.decimalDigits
                    
                    if word.rangeOfCharacter(from: digits) != nil {
                        
                    } else {
                        
                        attrString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.lightGray, range: matchRange)
                    }
                }
                
                if word.hasPrefix("https") {
                    
                    let matchRange: NSRange = nsText.range(of: word)
                    
                    attrString.addAttribute(NSLinkAttributeName, value: "link:\(word)", range: matchRange)
                }
            }
            
            
            tweetTextLabel?.attributedText = attrString
            if tweetTextLabel?.text != nil {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📸"
                }
            }
            
            tweetScreenNameLabel?.text = "\(tweet.user!)"
            
            if let profileImageURL = tweet.user.profileImageURL {
                if let imageData = NSData(contentsOf: (profileImageURL as URL)) { //Blocks main thread! *fix this*
                    let queue = DispatchQueue(label: "whatever", qos: .utility)
                    queue.async {
                        self.tweetProfileImageView?.image = UIImage(data: imageData as Data)
                    }
                }
            }
            
            let formatter = DateFormatter()
            if NSDate().timeIntervalSince(tweet.created as Date) > 24*60*60 {
                formatter.dateStyle = DateFormatter.Style.short
            } else {
                formatter.timeStyle = DateFormatter.Style.short
            }
            tweetCreatedLabel?.text = formatter.string(from: tweet.created as Date)
        }
    }
}
