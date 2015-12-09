//
//  NameTableViewController.swift
//  Collab
//
//  Created by Kiran Kunigiri on 12/8/15.
//  Copyright © 2015 Kiran Kunigiri. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class NameTableViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate,  UITableViewDelegate {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var confirmButton: UIButton!
    var blurView: UIVisualEffectView!
    
    let firebaseRef = Firebase(url:"https://collabios.firebaseio.com")
    var dataSource: FirebaseTableViewDataSource!
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        nameTextField.hidden = true
        nameTextField.alpha = 0
        confirmButton.hidden = true
        confirmButton.alpha = 0
        confirmButton.layer.cornerRadius = 5
        confirmButton.layer.borderColor = UIColor.whiteColor().CGColor
        confirmButton.layer.borderWidth = 2
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.view.bounds
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        blurView.addGestureRecognizer(tap)
        
        // Delegates
        self.nameTextField.delegate = self
        self.tableView.delegate = self
        
        // Firebase data
        self.dataSource = FirebaseTableViewDataSource(ref: self.firebaseRef, cellReuseIdentifier: "nameCell", view: self.tableView)
        
        self.dataSource.populateCellWithBlock { (cell: UITableViewCell, obj: NSObject) -> Void in
            let snap = obj as! FDataSnapshot
            
            // Populate cell as you see fit, like as below
            cell.textLabel?.text = snap.key as String
        }
        
        self.tableView.dataSource = self.dataSource
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addButtonPressed(sender: UIButton) {
        // Blur View
        self.blurView.alpha = 0
        self.nameTextField.hidden = false
        self.confirmButton.hidden = false
        
        self.view.insertSubview(blurView, belowSubview: nameTextField)
        UIView.animateWithDuration(0.5) { () -> Void in
            self.blurView.alpha = 1
            self.nameTextField.alpha = 1
            self.confirmButton.alpha = 1
        }
    }
    
    
    @IBAction func confirmButtonPressed(sender: UIButton) {
        let newFB = firebaseRef.childByAppendingPath(nameTextField.text)
        newFB.setValue("")
        dismissBlurView()
    }
    
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        dismissBlurView()
    }
    
    func dismissBlurView() {
        self.view.insertSubview(blurView, belowSubview: nameTextField)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.blurView.alpha = 0
            self.nameTextField.alpha = 0
            self.confirmButton.alpha = 0
            }) { (complete) -> Void in
                self.nameTextField.hidden = true
                self.confirmButton.hidden = true
                self.blurView.removeFromSuperview()
        }
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected")
        self.name = (tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text)!
        self.performSegueWithIdentifier("writeSegue", sender: self)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destVC = segue.destinationViewController as! ViewController
        let newFB = firebaseRef.childByAppendingPath(self.name)
        destVC.child = newFB
    }
    
    // Close the keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}
