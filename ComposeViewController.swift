//
//  ComposeViewController.swift
//  messagingapp
//
//  Created by Christopher Ching on 2016-11-22.
//  Copyright © 2016 CodeWithChris. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    //create a firebase ref
    var ref :DatabaseReference?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add a firebase ref
        ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPost(_ sender: Any) {
        
        // TODO: Post the data to firebase
        ref?.child("Post").childByAutoId().setValue(textView.text)
        
        
        // Dismiss the popover (dismiss the current viewcontroller)
        presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        
        // Dismiss the popover (dismiss the current viewcontroller)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
