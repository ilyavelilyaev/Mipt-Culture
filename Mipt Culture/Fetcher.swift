//
//  Fetcher.swift
//  Mipt Culture
//
//  Created by Ilya Velilyaev on 19.05.16.
//  Copyright © 2016 Ilya Velilyaev. All rights reserved.
//

import Foundation
import Parse
import AVReachability

class Fetcher {
    
    static func updateSavedData() {
        if !Reachability.isConnectedToNetwork() {
            NSNotificationCenter.defaultCenter().postNotificationName("connectionFailed", object: nil)
            NSNotificationCenter.defaultCenter().postNotificationName("updatedPerfomances", object: nil)
            return
        }
        
        let query = PFQuery(className: "Perfomances")
        query.whereKeyExists("date")
        query.whereKeyExists("name")
        query.whereKeyExists("theatre")
        query.whereKeyExists("price")
        query.whereKeyExists("regURL")
        query.whereKeyExists("adminURL")
        query.whereKeyExists("tablePicURL")
        query.whereKeyExists("description")

        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
            if let error = error {
                print ("Error while quering! \(error.localizedDescription)")
                self.updateSavedData()
                return
            }

            if let objects = objects {
                var perfomances = [Perfomance]()
                for object in objects {
                    let perfomance = Perfomance(
                        date: object["date"] as? NSDate,
                        name: object["name"] as! String,
                        theatre: object["theatre"] as? String,
                        price: object["price"] as! Int,
                        regURL: NSURL(string: object["regURL"] as! String),
                        adminURL: NSURL(string: object["adminURL"] as! String),
                        tablePicURL: NSURL(string: object["tablePicURL"] as! String)!,
                        descr: object["description"] as! String)
                    
                    perfomances.append(perfomance)
                }
                NSNotificationCenter.defaultCenter().postNotificationName("connectionRestored", object: nil)
                saveNewData(perfomances)
            }
        }
    }
    
    static func saveNewData(perfomances: [Perfomance]) {
        
        let newPerfs = perfomances.sort({ (first, second) -> Bool in
            return first.date!.compare(second.date!) == .OrderedAscending
        }).filter { (perf) -> Bool in
            return perf.date!.compare(NSDate()) == .OrderedDescending
        }
                
        if newPerfs.count == 0 {
            NSNotificationCenter.defaultCenter().postNotificationName("noPerfomances", object: nil)
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName("connectionRestored", object: nil)
        }
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(newPerfs, toFile: Perfomance.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save perfomances...")
            return
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("updatedPerfomances", object: nil)
    }
    
    

}