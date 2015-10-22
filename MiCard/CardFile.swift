//
//  CardFile.swift
//  MiCard
//
//  Created by Jake on 7/31/15.
//  Copyright (c) 2015 Jake. All rights reserved.
//

import Foundation
import CoreData

class CardFile: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var face1: String
    @NSManaged var face2: String
    @NSManaged var file: NSNumber
    @NSManaged var root: NSNumber
    @NSManaged var father: CardFile
    @NSManaged var children: NSSet
    
    var isfile: Bool {
        get {
            return Bool(file)
        }
        set {
            file = NSNumber(bool: newValue)
        }
    }
    
    var isroot: Bool {
        get {
            return Bool(root)
        }
        set {
            root = NSNumber(bool: newValue)
        }
    }
    
//    class func createInManagedObjectContext(moc: NSManagedObjectContext) -> CardFile {
//        let newItem = NSEntityDescription.insertNewObjectForEntityForName("File", inManagedObjectContext: moc) as! CardFile
//        return newItem
//    }
    
}

