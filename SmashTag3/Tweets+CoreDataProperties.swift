//
//  Tweets+CoreDataProperties.swift
//  SmashTag3
//
//  Created by Yuji Sakai on 1/28/17.
//  Copyright © 2017 Yuji Sakai. All rights reserved.
//

import Foundation
import CoreData


extension Tweets {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tweets> {
        return NSFetchRequest<Tweets>(entityName: "Tweets");
    }

    @NSManaged public var unique: String?
    @NSManaged public var text: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var tweeter: TwitterUser?

}
