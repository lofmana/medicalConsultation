//
//  HomeViewController.swift
//  messagingapp
//
//

import UIKit
import FirebaseDatabase
import SVProgressHUD
import FirebaseAuth

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var ref : DatabaseReference?
    var databaseHandle : DatabaseHandle?
    
    var postData = [String]()
    
    var num = 0
    
    
    
    @IBAction func signOut(_ sender: Any) {
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
        // Do any additional setup after loading the view, typically from a nib.
        
  
        
       
            
            
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            self.ref = Database.database().reference()
            
            self.ref?.child("Post").observe(.childAdded, with: { (snapshot) in
                
                //code to execute when a child is added under post
                //take value from the snapshot and added it to the postData array
                let post = snapshot.value as? String
                
                if let actualpost = post // check if the row is empty
                {
                    //append data to postData array
                    self.postData.append(actualpost)
                    
                    //reload the table view
                    self.tableView.reloadData()
                     SVProgressHUD.dismiss()
                    self.num = 1
                    
                    
                }
            })
                       // Bounce back to the main thread to update the UI
      
        
       
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        if num == 0
        {
      SVProgressHUD.show(withStatus: "Loading")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")
        cell?.textLabel?.text = postData[indexPath.row]
        
        return cell!
    }
    @IBAction func signout(_ sender: Any) {
        
        self.performSegue(withIdentifier: "login", sender: self)
        
    }
    
}

