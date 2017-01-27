//
//  Tweets+CoreDataClass.swift
//  SmashTag3
//
//  Created by Yuji Sakai on 1/26/17.
//  Copyright © 2017 Yuji Sakai. All rights reserved.
//

import Foundation
import CoreData
import Twitter


@objc(Tweets)
public class Tweets: NSManagedObject {

    class func tweetWithTwitterInfo(twitterInfo: Tweet, inManagedObjectContext context: NSManagedObjectContext) -> Tweets? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tweets")
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.id!)
        
        if let tweet = (try? context.fetch(request))?.first as? Tweets {
            return tweet
        } else if let tweet = NSEntityDescription.insertNewObject(forEntityName: "Tweets", into: context) as? Tweets {
            tweet.unique = twitterInfo.id
            tweet.text = twitterInfo.text
            tweet.posted = twitterInfo.created
            tweet.tweeter = TwitterUser.twitterUserWithTwitterInfo(twitterInfo: twitterInfo.user, inManagedObjectContext: context)
            return tweet
        }
        return nil
    }
}
