//
//  StudyDesk.swift
//  MiCard
//
//  Created by Jake on 7/21/15.
//  Copyright (c) 2015 Jake. All rights reserved.
//

import UIKit
import CoreData

class StudyDesk: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleLabel2: UILabel!
    @IBOutlet var headerView: UIView!
    @IBOutlet var textField: UITextField!
    
    var label1Active:Bool = true
    var labelIsAnimating:Bool = false
    
    var wrongAwn: Int = 0
    
    //Data
    var items = [CardFile]()
    var answer:String = ""
    var nextanswer:String = ""
    var counter:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel2.hidden = true
        
        let card1 = items[0]
        let card2 = items[1]
        self.titleLabel.text = card1.valueForKey("face1") as? String
        self.titleLabel2.text = card2.valueForKey("face1") as? String

        self.answer = (card1.valueForKey("face2") as? String)!
        self.nextanswer = (card2.valueForKey("face2") as? String)!
        
        self.textField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.donePressed(0);
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func currentCardIndex() -> Int {
        if (self.counter == self.items.count) {
            return 0
        } else {
            return self.counter
        }
    }
    
    func nextCardIndex() -> Int {
        self.counter = self.counter + 1
        if (self.counter == self.items.count) {
            self.counter = 0;
        }
        return self.counter;
    }
    
    func gotoNewCard() {
        self.labelIsAnimating = true
        
        if(self.label1Active) {
            self.titleLabel2.hidden = false
            self.titleLabel2.frame.origin.x = headerView.frame.width
        } else {
            self.titleLabel.hidden = false
            self.titleLabel.frame.origin.x = headerView.frame.width
        }
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            let headerFrame = self.headerView.frame
            var label1Frame:CGRect //label1Frame is always the currently centered
            var label2Frame:CGRect
            
            if(self.label1Active) {
                label1Frame = self.titleLabel.frame
                label2Frame = self.titleLabel2.frame
            } else {
                label1Frame = self.titleLabel2.frame
                label2Frame = self.titleLabel.frame
            }
            
            label2Frame = CGRectMake(self.view.center.x-(label2Frame.width/2), label2Frame.origin.y, label2Frame.width, label2Frame.height)
            label1Frame.origin.x = headerFrame.origin.x - label1Frame.width
            
            if(self.label1Active) {
                self.titleLabel.frame = label1Frame
                self.titleLabel2.frame = label2Frame
            } else {
                self.titleLabel.frame = label2Frame
                self.titleLabel2.frame = label1Frame
            }
            
            }, completion: { finished in
                //let ccard = self.items[self.currentCardIndex()] //current card
                let card = self.items[self.nextCardIndex()] // next in que card
                var face1: String
                var face2: String
                
                self.wrongAwn = 0 //reset counter
                self.answer = self.nextanswer
                let heads = self.flipCoin()
                if heads {
                    face1 = card.face1
                    face2 = card.face2
                } else {
                    face1 = card.face2
                    face2 = card.face1
                }
                
                if (self.label1Active) {
                    self.titleLabel.hidden = true
                    self.label1Active = false;
                    self.titleLabel.text = face1
                    self.nextanswer = face2
                } else {
                    self.titleLabel2.hidden = true
                    self.label1Active = true;
                    self.titleLabel2.text = face1
                    self.nextanswer = face2
                }
                
                self.textField.text = ""
                
                //self.textField.text = (ccard.valueForKey("face2") as? String)!
                print(self.answer)
                self.labelIsAnimating = false
        })
        
    }
    
    func checkAnswer() {
        if self.labelIsAnimating {
            return
        }
        
        if (self.answer.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).stringByTrimmingCharactersInSet(NSCharacterSet.controlCharacterSet()) == self.textField.text!.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).stringByTrimmingCharactersInSet(NSCharacterSet.controlCharacterSet())) {
            self.gotoNewCard()
        } else {
            self.wrongAwn++
            if self.wrongAwn == 3 {
                self.wrongAwn = 0
                self.textField.text = self.answer
            }
            UIView.animateWithDuration(0.1, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 30.0, options:[], animations: ({
                if (self.label1Active) {
                    let labelFrame = self.titleLabel.frame
                    self.titleLabel.frame = CGRectMake(self.view.center.x-(labelFrame.width/1.6), labelFrame.origin.y, labelFrame.width, labelFrame.height)
                } else {
                    let labelFrame = self.titleLabel2.frame
                    self.titleLabel2.frame = CGRectMake(self.view.center.x-(labelFrame.width/1.6), labelFrame.origin.y, labelFrame.width, labelFrame.height)
                }
            }), completion: {finish in
                UIView.animateWithDuration(0.8, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 30.0, options:[], animations: ({
                    if (self.label1Active) {
                        let labelFrame = self.titleLabel.frame
                        self.titleLabel.frame = CGRectMake(self.view.center.x-(labelFrame.width/2), labelFrame.origin.y, labelFrame.width, labelFrame.height)
                    } else {
                        let labelFrame = self.titleLabel2.frame
                        self.titleLabel2.frame = CGRectMake(self.view.center.x-(labelFrame.width/2), labelFrame.origin.y, labelFrame.width, labelFrame.height)
                    }
                }), completion: {finish in
                    
                })
            })
            
        }
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        if(!self.labelIsAnimating){
            self.checkAnswer()
        }
    }

    @IBAction func nextCardPressed(sender: AnyObject) {
        if(!self.labelIsAnimating){
            self.gotoNewCard()
        }
    }
    
    @IBAction func closePressed(sender: AnyObject) {
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func flipCoin() -> Bool {
        let coinToss = Int(arc4random_uniform(2))
        return coinToss == 0
    }
}
