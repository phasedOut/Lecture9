//
//  SearchHistory.swift
//  SmashTag3
//
//  Created by Yuji Sakai on 1/22/17.
//  Copyright © 2017 Yuji Sakai. All rights reserved.
//

import Foundation

class SearchHistory {

    struct History {
        
        static var history = [String]()
        
        static func register() {
            UserDefaults.standard.register(defaults: ["history" : [String]()])
        }
        
        static func load() {
            History.history = UserDefaults.standard.object(forKey: "history") as! [String]
        }
        
        static func save() {
            UserDefaults.standard.set(History.history, forKey: "history")
        }
        
        static func clear() {
            history.removeAll()
        }
        
        static func delete(index: Int) {
            history.remove(at: index)
        }
        
        static func append(string: String) {
            if !string.isEmpty{
                History.history.insert(string, at: 0)
            }
        }
    }
}
