//
//  ViewController.swift
//  Collab
//
//  Created by Kiran Kunigiri on 12/8/15.
//  Copyright © 2015 Kiran Kunigiri. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var backButton: UIButton!
    
    var root = Firebase(url:"https://collabios.firebaseio.com")
    var child: Firebase!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Delegate setup
        self.textView.delegate = self
        
        // Update textview from firebase
        child.observeEventType(.Value, withBlock: { snapshot in
            self.textView.text = snapshot.value as? String
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    // Update firebase as soon as textView text changes
    func textViewDidChange(textView: UITextView) {
        child.setValue(self.textView.text!)
    }
    
    // Dismiss view controller with back button
    @IBAction func backButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    
    // Close the keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}