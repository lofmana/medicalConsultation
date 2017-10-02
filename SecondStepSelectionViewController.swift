//
//  SecondStepSelectionViewController.swift
//  medicalConsultation
//
//  Created by Adam Tan on 28/9/17.
//  Copyright © 2017 Adam Tan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class SecondStepSelectionViewController: UIViewController {
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    
    var ref : DatabaseReference?
    var databaseHandle : DatabaseHandle?
    var data = [String]()
    var id = [Int]()
    var cellArray = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        labelOne.text = String(finalArray[0])
        
        
       // self.ref = Database.database().reference()
        
        let databaseRef = Database.database().reference().child("Disease")
//
//        databaseRef.child("Disease").child("Cold").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
//
//            if snapshot.hasChild("Cold"){
//
//                print("true rooms exist")
//
//            }else{
//
//                print("false room doesn't exist")
//            }
//
//
//        })
      
        let query = databaseRef.queryOrdered(byChild: "sym1").queryEqual(toValue: "1")

     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
