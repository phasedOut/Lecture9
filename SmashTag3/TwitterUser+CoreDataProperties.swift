//
//  TwitterUser+CoreDataProperties.swift
//  SmashTag3
//
//  Created by Yuji Sakai on 1/26/17.
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
