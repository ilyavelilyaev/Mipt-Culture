//
//  Perfomance.swift
//  Mipt Culture
//
//  Created by Ilya Velilyaev on 19.05.16.
//  Copyright © 2016 Ilya Velilyaev. All rights reserved.
//

import Foundation

class Perfomance: NSObject, NSCoding {
    var date: NSDate?
    var photoURL: NSURL? 
    var name: String!
    var theatre: String?
    var price: Int!
    var regURL: NSURL?
    var adminURL: NSURL?
    var tablePicURL: NSURL!
    
    struct PropertyKey {
        static let dateKey = "date"
        static let photoURLKey = "photoURL"
        static let nameKey = "name"
        static let theatreKey = "theatre"
        static let priceKey = "price"
        static let regURLKey = "regURL"
        static let adminURLKey = "adminURL"
        static let tablePicURLKey = "tablePicURL"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(price, forKey: PropertyKey.priceKey)
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
        aCoder.encodeObject(photoURL, forKey: PropertyKey.photoURLKey)
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(theatre, forKey: PropertyKey.theatreKey)
        aCoder.encodeObject(regURL, forKey: PropertyKey.regURLKey)
        aCoder.encodeObject(adminURL, forKey: PropertyKey.adminURLKey)
        aCoder.encodeObject(tablePicURL, forKey: PropertyKey.tablePicURLKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as? NSDate
        let photoURL = aDecoder.decodeObjectForKey(PropertyKey.photoURLKey) as? NSURL
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let theatre = aDecoder.decodeObjectForKey(PropertyKey.theatreKey) as? String
        let price = aDecoder.decodeIntegerForKey(PropertyKey.priceKey)
        let regURL = aDecoder.decodeObjectForKey(PropertyKey.regURLKey) as? NSURL
        let adminURL = aDecoder.decodeObjectForKey(PropertyKey.adminURLKey) as? NSURL
        let tablePicURL = aDecoder.decodeObjectForKey(PropertyKey.tablePicURLKey) as! NSURL
        self.init(date: date, photoURL: photoURL, name: name, theatre: theatre, price: price, regURL: regURL, adminURL: adminURL, tablePicURL: tablePicURL)
    }
    
    init (date: NSDate?, photoURL: NSURL?, name: String,
           theatre: String?, price: Int, regURL: NSURL?,
           adminURL: NSURL?, tablePicURL: NSURL) {
        self.date = date
        self.photoURL = photoURL
        self.name = name
        self.theatre = theatre
        self.price = price
        self.regURL = regURL
        self.adminURL = adminURL
        self.tablePicURL = tablePicURL
        super.init()
    }
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("perfomances")
}

