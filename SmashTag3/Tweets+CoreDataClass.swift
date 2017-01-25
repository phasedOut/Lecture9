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


public class Tweets: NSManagedObject {

    class func tweetWithTwitterInfo(twitterInfo: Tweet, inManagedObjectContext context: NSPersistentContainer) -> Tweets? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tweet")
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.id!)
        
        do {
            let queryResults = try context.viewContext.exe
            if let tweet = queryResults as? Tweets{
                return tweet
            }
        } catch let error {
            //ignore
        }
        
    }
}
