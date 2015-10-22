//
//  ShareVC.swift
//  MiCard
//
//  Created by Jake on 8/30/15.
//  Copyright (c) 2015 Jake. All rights reserved.
//

import UIKit

class ShareVC: UIViewController {

    var parent:CardFile? = nil
    var serviceManager = ServiceManager()
    var tableData = [String]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendPressed(sender: AnyObject) {
        serviceManager.sendColor("red")
    }

    @IBAction func closePressed(sender: AnyObject) {
        serviceManager.kill()
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func changeColor(color : UIColor) {
        UIView.animateWithDuration(0.2) {
            self.view.backgroundColor = color
        }
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

extension ShareVC : ServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: ServiceManager, connectedDevices: [String]) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            //self.connectionsLabel.text = "Connections: \(connectedDevices)"
            NSLog("%@", "I got some Connections: \(connectedDevices)")
            self.tableData = connectedDevices
            self.tableView.reloadData()
        }
    }
    
    func colorChanged(manager: ServiceManager, colorString: String) {
        NSOperationQueue.mainQueue().addOperationWithBlock {
            switch colorString {
            case "red":
                self.changeColor(UIColor.redColor())
            case "yellow":
                self.changeColor(UIColor.yellowColor())
            default:
                NSLog("%@", "Unknown color value received: \(colorString)")
            }
        }
    }
    
}

extension ShareVC : UITableViewDelegate, UITableViewDataSource {
    //MARK: TableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("device", forIndexPath: indexPath)
        
        cell.textLabel?.text = self.tableData[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
}


