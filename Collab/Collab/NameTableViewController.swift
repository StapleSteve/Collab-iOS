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

class NameTableViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addButton: UIButton!
    
    let firebaseRef = Firebase(url:"https://collabios.firebaseio.com")
    var dataSource: FirebaseTableViewDataSource!
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        
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
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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


}
