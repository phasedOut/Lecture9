//
//  TwitterUser+CoreDataProperties.swift
//  SmashTag3
//
//  Created by Yuji Sakai on 1/25/17.
//  Copyright © 2017 Yuji Sakai. All rights reserved.
//

import Foundation
import CoreData


extension TwitterUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TwitterUser> {
        return NSFetchRequest<TwitterUser>(entityName: "TwitterUser");
    }

    @NSManaged public var name: String?
    @NSManaged public var screenName: String?
    @NSManaged public var tweets: NSSet?

}

// MARK: Generated accessors for tweets
extension TwitterUser {

    @objc(addTweetsObject:)
    @NSManaged public func addToTweets(_ value: Tweets)

    @objc(removeTweetsObject:)
    @NSManaged public func removeFromTweets(_ value: Tweets)

    @objc(addTweets:)
    @NSManaged public func addToTweets(_ values: NSSet)

    @objc(removeTweets:)
    @NSManaged public func removeFromTweets(_ values: NSSet)

}
