//
//  NewItemNavVC.swift
//  MiCard
//
//  Created by Jake on 8/1/15.
//  Copyright (c) 2015 Jake. All rights reserved.
//

import UIKit

protocol EditorDelegate {
    func databaseDidChange()
}

class NewItemNavVC: UINavigationController {
    
    var insertCard: CardFile? = nil
    
    var edit_delegate: EditorDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
