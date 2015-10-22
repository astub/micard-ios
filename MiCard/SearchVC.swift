//
//  SearchVC.swift
//  MiCard
//
//  Created by Jake on 8/4/15.
//  Copyright (c) 2015 Jake. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var data = [CardFile]()
    var filtered = [CardFile]()
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.enableCancleButton(self.searchBar)
        // Do any additional setup after loading the view.
        
        data = SuperDeck().allcards.sort {$0.face1 < $1.face1}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
    }
    
    func enableCancleButton (searchBar : UISearchBar) {
        for view1 in searchBar.subviews {
            for view2 in view1.subviews {
                if view2.isKindOfClass(UIButton) {
                    let button = view2 as! UIButton
                    button.enabled = true
                    button.tintColor = Helper().redColor()
                    button.setTitleColor(Helper().redColor(), forState: UIControlState.Disabled)
                    button.userInteractionEnabled = true
                }
            }
        }
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            searchActive = false;
            self.tableView.reloadData()
            return
        }
        
        filtered = data.filter({( card: CardFile) -> Bool in
            let tmp: NSString = card.face1
            let tmp2: NSString = card.face2
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            let range2 = tmp2.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound || range2.location != NSNotFound
        })

        searchActive = true;
        
        self.tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("sitem") as! UITableViewCell;
        let cell = tableView.dequeueReusableCellWithIdentifier("sitem", forIndexPath: indexPath)
        
        cell.selectionStyle = .None
        
        if(!searchActive){
            let card = data[indexPath.row]
            cell.textLabel?.text = card.face1
            cell.detailTextLabel?.text = card.face2
        } else {
            let card = filtered[indexPath.row]
            cell.textLabel?.text = card.face1
            cell.detailTextLabel?.text = card.face2
        }
        
        
        return cell;
    }

}


