//
//  SuperDeck.swift
//  MiCard
//
//  Created by Jake on 8/1/15.
//  Copyright (c) 2015 Jake. All rights reserved.
//

import UIKit
import CoreData

class SuperDeck: NSObject {
    var parent: CardFile? = nil
    var cards = [CardFile]() //TopCards
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var allcards = [CardFile]()
    
    override init() {
        super.init()
        let predicate = NSPredicate(format: "root == %@", NSNumber(bool: true))
        let fetchRequest = NSFetchRequest(entityName:"CardFile")
        fetchRequest.predicate = predicate
        
        if let fetchResults = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [CardFile] {
            print("Making SuperDeck")
            parent = fetchResults.first!
            let children = parent!.children//supercard?.mutableSetValueForKey("children")
            cards = children.allObjects as! [CardFile]
        }
        
        let predicate2 = NSPredicate(format: "file == %@", NSNumber(bool: false))
        fetchRequest.predicate = predicate2;
        if let fetchResults2 = (try? managedObjectContext!.executeFetchRequest(fetchRequest)) as? [CardFile] {
            allcards = fetchResults2
        }
        
    }
    
    func addObject(obj:CardFile, toparent prt:CardFile) {
        obj.father = prt
        
        var error: NSError?
        do {
            try managedObjectContext!.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func removeObject(obj:CardFile) {
        
        for item in obj.children.allObjects {
            removeObject(item as! CardFile)
        }
        
        managedObjectContext?.deleteObject(obj)
        
        var error: NSError?
        do {
            try managedObjectContext!.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func addItemDict(item:NSDictionary, toparent prt:CardFile) {
        
        
        let isfile:Bool = item.objectForKey("isfile") as! Bool
        let name:String = item.objectForKey("name") as! String
        let face1:String = item.objectForKey("face1") as! String
        let face2:String = item.objectForKey("face2") as! String
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("CardFile", inManagedObjectContext: managedObjectContext!) as! CardFile
        newItem.father = prt
        newItem.isfile = isfile
        newItem.name = name
        newItem.face1 = face1
        newItem.face2 = face2
        
        let s_children:NSArray = item.objectForKey("children") as! NSArray
        for child in s_children {
            addItemDict(child as! NSDictionary, toparent: newItem)
        }
        
        var error: NSError?
        do {
            try managedObjectContext!.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
        
    }
    
    func addPlistToRoot(plist:String) {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = NSURL(fileURLWithPath: documentsDirectory).URLByAppendingPathComponent(plist+".plist") //documentsDirectory.stringByAppendingPathComponent(plist+".plist")
        let fileManager = NSFileManager.defaultManager()
        if(!fileManager.fileExistsAtPath(path.absoluteString)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource(plist, ofType: "plist") {
                
                //let resultDictionary = NSMutableArray(contentsOfFile: bundlePath)
                do {
                    //println("Bundle GameData.plist file is --> \(resultDictionary?.description)")
                
                    try fileManager.copyItemAtPath(bundlePath, toPath: path.absoluteString)
                } catch _ {
                }
                print("copy")
            } else {
                print("plist not found. Please, make sure it is part of the bundle.")
            }
            
        } else {
            print("plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        
        let resultArray = NSMutableArray(contentsOfFile: path.absoluteString)
        // println("Loaded GameData.plist file is --> \(resultDictionary?.description)")
        
        if let items = resultArray {
            for item in items {
                addItemDict(item as! NSDictionary, toparent: self.parent!)
            }
        }
        /////
    }
    
    func cardsUnderParent(prt: CardFile) -> [CardFile] {
        var cards = [CardFile]()
        
        for c: CardFile in prt.children.allObjects as! [CardFile] {
            if c.isfile {
                cards = cards + cardsUnderParent(c)
            } else {
                cards.append(c)
            }
        }
        
        return cards
    }
    
    
}
