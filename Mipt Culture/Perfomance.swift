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
    var name: String!
    var theatre: String?
    var price: Int!
    var regURL: NSURL?
    var adminURL: NSURL?
    var tablePicURL: NSURL!
    var descr: String
    
    struct PropertyKey {
        static let dateKey = "date"
        static let nameKey = "name"
        static let theatreKey = "theatre"
        static let priceKey = "price"
        static let regURLKey = "regURL"
        static let adminURLKey = "adminURL"
        static let tablePicURLKey = "tablePicURL"
        static let descrKey = "descr"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(price, forKey: PropertyKey.priceKey)
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(theatre, forKey: PropertyKey.theatreKey)
        aCoder.encodeObject(regURL, forKey: PropertyKey.regURLKey)
        aCoder.encodeObject(adminURL, forKey: PropertyKey.adminURLKey)
        aCoder.encodeObject(tablePicURL, forKey: PropertyKey.tablePicURLKey)
        aCoder.encodeObject(descr, forKey: PropertyKey.descrKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as? NSDate
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let theatre = aDecoder.decodeObjectForKey(PropertyKey.theatreKey) as? String
        let price = aDecoder.decodeIntegerForKey(PropertyKey.priceKey)
        let regURL = aDecoder.decodeObjectForKey(PropertyKey.regURLKey) as? NSURL
        let adminURL = aDecoder.decodeObjectForKey(PropertyKey.adminURLKey) as? NSURL
        let tablePicURL = aDecoder.decodeObjectForKey(PropertyKey.tablePicURLKey) as! NSURL
        let descr = aDecoder.decodeObjectForKey(PropertyKey.descrKey) as! String
        self.init(date: date, name: name, theatre: theatre, price: price, regURL: regURL, adminURL: adminURL, tablePicURL: tablePicURL, descr: descr)
    }
    
    init (date: NSDate?, name: String,
           theatre: String?, price: Int, regURL: NSURL?,
           adminURL: NSURL?, tablePicURL: NSURL, descr: String) {
        self.date = date
        self.name = name
        self.theatre = theatre
        self.price = price
        self.regURL = regURL
        self.adminURL = adminURL
        self.tablePicURL = tablePicURL
        self.descr = descr
        super.init()
    }
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("perfomances")
}

