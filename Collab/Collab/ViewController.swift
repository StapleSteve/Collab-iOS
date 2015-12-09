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
    
    var myRootRef = Firebase(url:"https://collabios.firebaseio.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.textView.delegate = self
        
        myRootRef.observeEventType(.Value, withBlock: { snapshot in
            self.textView.text = snapshot.value as! String
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func textViewDidChange(textView: UITextView) {
        print("We are changing")
        myRootRef.setValue(self.textView.text!)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}