//
//  TypeSelectionVC.swift
//  MiCard
//
//  Created by Jake on 8/1/15.
//  Copyright (c) 2015 Jake. All rights reserved.
//

import UIKit

class TypeSelectionVC: UIViewController {

    @IBOutlet var topView: UIView!
    @IBOutlet var btmView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topView.layer.cornerRadius = 10.0
        topView.layer.borderColor = UIColor.grayColor().CGColor
        topView.layer.borderWidth = 0.9
        
        btmView.layer.cornerRadius = 10.0
        btmView.layer.borderColor = UIColor.grayColor().CGColor
        btmView.layer.borderWidth = 0.9
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: {})
    }

    @IBAction func topviewTapped(sender: AnyObject) {
        print("card")
        let vc:CardEditor = self.storyboard!.instantiateViewControllerWithIdentifier("CardEditor") as! CardEditor
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btmviewTapped(sender: AnyObject) {
        print("file")
        let vc:CardEditor = self.storyboard!.instantiateViewControllerWithIdentifier("CardEditor") as! CardEditor
        vc.isEditingFile = true
        self.navigationController?.pushViewController(vc, animated: true)
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
