//
//  PreMainViewController.swift
//  medicalConsultation
//
//  Created by Adam Tan on 22/6/17.
//  Copyright © 2017 Adam Tan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SVProgressHUD
import FirebaseAuth

class PreMainViewController: UIViewController {


     let databaseRef = Database.database().reference(fromURL : "https://medicalconsultation.firebaseio.com")
    
    @IBOutlet weak var whiteImage: UIView!
    
  
   
    @IBAction func btnSignout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        self.performSegue(withIdentifier: "signout", sender: self)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.performSegue(withIdentifier: "", sender: self)
        
        whiteImage.layer.cornerRadius = 3
        
    
        
        let userID = Auth.auth().currentUser?.uid
        databaseRef.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["NRIC"] as? String ?? ""
            
            print(username)
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
       
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            }
    

    @IBAction func btnCon(_ sender: Any) {
        
        self.performSegue(withIdentifier: "voiceConsultation", sender: self)

    }
   
    @IBAction func btnViewReport(_ sender: Any) {
        
        self.performSegue(withIdentifier: "viewReport", sender: self)
        
    }
    @IBAction func btnEditProfile(_ sender: Any) {
        self.performSegue(withIdentifier: "editProfile", sender: self)
    }
}
