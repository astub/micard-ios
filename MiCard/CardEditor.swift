//
//  CardEditor.swift
//  MiCard
//
//  Created by Jake on 7/19/15.
//  Copyright (c) 2015 Jake. All rights reserved.
//

import UIKit
import CoreData

class CardEditor: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var textCellIdentifier: String = "InputCell"
    var items: [String] = ["Face 1", "Face 2"]
    
    var editingCard: CardFile! = nil
    //var superdeck: SuperDeck = SuperDeck()
    var isEditingFile: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("CardEditor VDL")
        
        self.navigationController?.navigationBar.tintColor = Helper().blueColor()
        self.tableView.backgroundColor = nil
        
        if self.isEditingFile {
            self.navigationItem.title = "File"
        } else {
            self.navigationItem.title = "Card"
        }
        
        
        if self.editingCard != nil {
            let a = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: Selector("close"))
            a.tintColor = Helper().redColor()
            self.navigationItem.leftBarButtonItem = a
        }
        
        let b = UIBarButtonItem(title: "Save", style: .Done, target: self, action: Selector("savePressed:"))
        b.tintColor = Helper().greenColor()
        self.navigationItem.rightBarButtonItem = b
        
    }
    
    func close() {
        let nav = self.navigationController as! NewItemNavVC
        nav.edit_delegate?.databaseDidChange()
        
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewTapped(sender: AnyObject) {
        self.view.endEditing(true)
    }
    //TableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            if self.isEditingFile {
                return 1
            } else {
                return 2
            }
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            
            let cell :InputCell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier) as! InputCell
            
            if self.isEditingFile {
                cell.titleLabel.text = "Name"
                if (editingCard != nil) {
                    cell.input.text = editingCard.name
                }
            } else {
                cell.titleLabel.text = items[indexPath.row]
                if (editingCard != nil) {
                    if (indexPath.row == 0) {
                        cell.input.text = editingCard.face1
                    } else {
                        cell.input.text = editingCard.face2
                    }
                }
            }
            
            cell.selectionStyle = .None
            return cell
        } else {
            
            //let cell :UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ComitCell") as! UITableViewCell
            let cell = tableView.dequeueReusableCellWithIdentifier("ComitCell", forIndexPath: indexPath)
            return cell
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // Functionality
    
    @IBAction func savePressed(sender: AnyObject) {
        if self.isEditingFile {
            let index1: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
            let cell1: InputCell = tableView.cellForRowAtIndexPath(index1) as! InputCell
            let name = cell1.input.text
            if (name!.isEmpty) {
                cell1.titleLabel.textColor = UIColor.redColor()
                return
            } else {
                self.saveCard(name!, face2: "")
                self.close()
            }
            
        } else {
            let index1: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
            let index2: NSIndexPath = NSIndexPath(forRow: 1, inSection: 0)
            
            let cell1: InputCell = tableView.cellForRowAtIndexPath(index1) as! InputCell
            let cell2: InputCell = tableView.cellForRowAtIndexPath(index2) as! InputCell
            
            let face1 = cell1.input.text
            let face2 = cell2.input.text
            
            if (face1!.isEmpty) {
                cell1.titleLabel.textColor = UIColor.redColor()
                return
            } else if (face2!.isEmpty) {
                cell2.titleLabel.textColor = UIColor.redColor()
                return
            } else {
                self.saveCard(face1!, face2: face2!)
                self.close()
            }
        }
    }
    
    func saveCard(s1: String, face2: String) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        //let entity =  NSEntityDescription.entityForName("Card", inManagedObjectContext: managedContext)
        
        if (editingCard != nil) {
            print("updatecard")
            if self.isEditingFile {
                editingCard.name = s1
            } else {
                editingCard.face1 = s1
                editingCard.face2 = face2
            }
        } else {
            print("newcard")
            let nav = self.navigationController as! NewItemNavVC
            let father = nav.insertCard
            
            let newCard = NSEntityDescription.insertNewObjectForEntityForName("CardFile", inManagedObjectContext: managedContext) as! CardFile
            if self.isEditingFile {
                newCard.isfile = true
                newCard.name = s1
                newCard.father = father!
            } else {
                newCard.isfile = false
                newCard.face1 = s1
                newCard.face2 = face2
                newCard.father = father!
            }
        }
        
        var error: NSError?
        do {
            try managedContext.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }


}


