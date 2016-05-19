//
//  Fetcher.swift
//  Mipt Culture
//
//  Created by Ilya Velilyaev on 19.05.16.
//  Copyright © 2016 Ilya Velilyaev. All rights reserved.
//

import Foundation
import Parse

class Fetcher {
    
    static func updateSavedData() {
        let query = PFQuery(className: "Perfomances")
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
            if error == nil {
                print("No error while fetching.")
                if let objects = objects {
                    var perfomances = [Perfomance]()
                    for object in objects {
                        let perfomance = Perfomance(date: object["date"] as? NSDate,
                            photoURL: NSURL(string: object["photoURL"] as! String),
                            name: object["name"] as! String,
                            theatre: object["theatre"] as? String,
                            price: object["price"] as! Int,
                            regURL: NSURL(string: object["regURL"] as! String),
                            adminURL: NSURL(string: object["adminURL"] as! String),
                            tablePicURL: NSURL(string: object["tablePicURL"] as! String)!)
                        perfomances.append(perfomance)
                    }
                    saveNewData(perfomances)
                }
            }
        }
    }
    
    static func saveNewData(perfomances: [Perfomance]) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(perfomances, toFile: Perfomance.ArchiveURL.path!)
        NSNotificationCenter.defaultCenter().postNotificationName("updatedPerfomances", object: nil)
        if !isSuccessfulSave {
            print("Failed to save perfomances...")
        }
    }

}