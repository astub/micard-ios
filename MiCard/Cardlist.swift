//
//  Cardlist.swift
//  MiCard
//
//  Created by Jake on 7/19/15.
//  Copyright (c) 2015 Jake. All rights reserved.
//

import UIKit
import CoreData

class Cardlist: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, EditorDelegate {
    @IBOutlet var tableView: UITableView!
    
    var items = [CardFile]()
    var parent:CardFile? = nil
    
    var cards = [CardFile]()
    var decks = [CardFile]() //basicly pickers datasource
    
    var picker:UIPickerView = UIPickerView()
    var eIndex:NSIndexPath = NSIndexPath()
    
    // ViewController Stuff
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Cardlist VDL")
        
        self.picker.delegate = self;
        self.picker.dataSource = self;
        
        self.reloadTableData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadTableData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: TableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let card = self.items[indexPath.row]
        
        if card.isfile {
            
            //let cell = tableView.dequeueReusableCellWithIdentifier("FileCell") as! UITableViewCell
            let cell = tableView.dequeueReusableCellWithIdentifier("FileCell", forIndexPath: indexPath)
            cell.textLabel?.text = card.name
            return cell
        } else {
            //let cell = tableView.dequeueReusableCellWithIdentifier("CardCell") as! UITableViewCell
            let cell = tableView.dequeueReusableCellWithIdentifier("CardCell", forIndexPath: indexPath)
            cell.textLabel?.text = card.face1
            cell.detailTextLabel?.text = card.face2
            cell.selectionStyle = .None
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let card = self.items[indexPath.row]
        
        if card.isfile {
            let vc:Cardlist  = self.storyboard!.instantiateViewControllerWithIdentifier("Cardlist") as! Cardlist
            vc.parent = card
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        
        self.eIndex = indexPath
        
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Edit" , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            let card = self.items[indexPath.row]
            let shareMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            if card.isfile {
                shareMenu.message = card.name
            } else {
                shareMenu.message = card.face1 + " - " + card.face2
            }
            
            let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: self.deleteCell)
            let twitterAction = UIAlertAction(title: "Edit Text", style: UIAlertActionStyle.Default, handler: self.editCell)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            shareMenu.addAction(deleteAction)
            shareMenu.addAction(twitterAction)
            shareMenu.addAction(cancelAction)
            
            // for iPAD support:
            shareMenu.popoverPresentationController?.sourceView = self.view
            shareMenu.popoverPresentationController?.sourceRect = CGRectMake(0, (self.view.bounds.height/2.0)-50, 1.0, 1.0)
            //shareMenu.popoverPresentationController?.arrowDirection
            
            shareMenu.view.tintColor = Helper().blueColor()
            self.presentViewController(shareMenu, animated: true, completion: nil)
        })
        shareAction.backgroundColor = Helper().redColor()
        
        let rateAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Move" , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            let card = self.items[indexPath.row]
            //remake decks w/0 file
            self.remakeDecksWithOut(card.objectID)
            if card.isfile {
                if self.parent?.father == nil && self.decks.count == 0 {
                    let alert = UIAlertController(title: "No other folder", message: "add more folders", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    self.showPicker("("+card.name+")")
                }
            } else {
                if self.parent?.father == nil && self.decks.count == 0 {
                    
                } else {
                    self.showPicker("("+card.face1+" - "+card.face2+")")
                }
            }
            
        })
        rateAction.backgroundColor = Helper().greenColor()
        
        return [shareAction,rateAction]
    }
    
    func deleteCell(alert: UIAlertAction!) {
        // Do something...
        let alert = UIAlertController(title: "Delete?", message: "deleting a file will remove all cards & files in side", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction) in
            SuperDeck().removeObject(self.items[self.eIndex.row])
            self.reloadTableData()
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func editCell(alert: UIAlertAction!) {
        performSegueWithIdentifier("edit", sender: alert)
    }
    
    func reloadTableData() {
        print("reloading data sources...")
        if ((parent) != nil) {
            self.navigationItem.title = parent!.name
            let children = parent!.children
            self.items = children.allObjects as! [CardFile]
        } else {
            let sd = SuperDeck()
            self.navigationItem.title = "みCards"
            self.items = sd.cards
            self.parent = sd.parent
        }
        
        self.decks = [CardFile]()
        self.cards = [CardFile]()
        for item in items {
            if item.isfile {
                self.decks.append(item)
            } else {
                self.cards.append(item)
            }
        }
        
        self.items = self.decks + self.cards
        
        self.tableView.reloadData()
    }
    
    func remakeDecksWithOut(o_id: NSManagedObjectID) {
        self.decks = [CardFile]()
        for item in items {
            if (item.isfile && item.objectID != o_id) {
                self.decks.append(item)
            }
        }
    }
    
    //MARK: Segue
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "desk" && 2 >= SuperDeck().cardsUnderParent(self.parent!).count {
            return false
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "NewItem" {
            let nav = segue.destinationViewController as! NewItemNavVC
            nav.insertCard = parent
            nav.edit_delegate = self
            return
        }
        
        if segue.identifier == "desk" {
            let desk: StudyDesk = segue.destinationViewController as! StudyDesk
            desk.items = SuperDeck().cardsUnderParent(self.parent!);
            return
        }
        
        if segue.identifier == "edit" {
            
            let card = self.items[eIndex.row]
            
            let nav: NewItemNavVC = segue.destinationViewController as! NewItemNavVC
            let vc:CardEditor = self.storyboard!.instantiateViewControllerWithIdentifier("CardEditor") as! CardEditor
            vc.editingCard = card
            vc.isEditingFile = card.isfile
            nav.setViewControllers([vc], animated: true)
            nav.edit_delegate = self
            
            return
        }
    }
    
    //MARK: Editor Delageate
    func databaseDidChange() {
        reloadTableData()
    }
    
    //MARK: Picker Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.parent?.father == nil {
            return self.decks.count
        } else {
            return self.decks.count+1
        }
    }
    
    //MARK: Picker Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == self.decks.count {
            return "Back"//parent?.father.name
        } else {
            let deck = decks[row]
            return deck.name
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //println(row)
    }
    
    func showPicker(title: String) {
        let title = "Move " + title
        let message = "\n\n\n\n\n\n\n\n\n\n";
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.ActionSheet);
        alert.modalInPopover = true;
        
        let pickerFrame: CGRect = CGRectMake(10, 52, 280, 162.0);
        //var picker: UIPickerView = UIPickerView(frame: pickerFrame);
        self.picker.frame = pickerFrame

        alert.view.addSubview(self.picker);

        //Create the toolbar view - the view witch will hold our 2 buttons
        let toolFrame = CGRectMake(17, 5, 270, 55);
        let toolView: UIView = UIView(frame: toolFrame);

        let buttonCancelFrame: CGRect = CGRectMake(0, 25, 100, 30);
        
        let buttonCancel: UIButton = UIButton(frame: buttonCancelFrame);
        buttonCancel.setTitle("Cancel", forState: UIControlState.Normal);
        buttonCancel.setTitleColor(Helper().blueColor(), forState: UIControlState.Normal);
        toolView.addSubview(buttonCancel);
        buttonCancel.addTarget(self, action: "cancelPicker:", forControlEvents: UIControlEvents.TouchDown);

        let buttonOkFrame: CGRect = CGRectMake(170, 25, 100, 30);
        
        let buttonOk: UIButton = UIButton(frame: buttonOkFrame);
        buttonOk.setTitle("Select", forState: UIControlState.Normal);
        buttonOk.setTitleColor(Helper().blueColor(), forState: UIControlState.Normal);
        toolView.addSubview(buttonOk);
        buttonOk.addTarget(self, action: "selectPicker:", forControlEvents: UIControlEvents.TouchDown);

        //add the toolbar to the alert controller
        alert.view.addSubview(toolView);

        // for iPAD support:
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(0, self.view.bounds.height / 2.0, 1.0, 1.0) // this is the center of the screen currently
        
        self.presentViewController(alert, animated: true, completion: nil);
    }
    
    func cancelPicker(sender: UIButton!) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func selectPicker(sender: UIButton!) {
        let row = self.picker.selectedRowInComponent(0)
        if row == self.decks.count {
            SuperDeck().addObject(self.items[eIndex.row], toparent: self.parent!.father)
        } else {
            SuperDeck().addObject(self.items[eIndex.row], toparent: self.decks[row])
        }
        
        //var moid = self.decks[row].objectID
        self.dismissViewControllerAnimated(true, completion: nil);
        self.reloadTableData()
    }

}
