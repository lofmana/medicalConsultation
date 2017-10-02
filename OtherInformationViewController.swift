//
//  OtherInformationViewController.swift
//  medicalConsultation
//
//  Created by Adam Tan on 4/7/17.
//  Copyright © 2017 Adam Tan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SVProgressHUD
import FirebaseAuth


class OtherInformationViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var tableView: UITableView!
    var ref : DatabaseReference?
    var databaseHandle : DatabaseHandle?
    
    var data = [String]()
    var id = [Int]()
    var cellArray = [Int]()
    
    var num = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.ref = Database.database().reference()
        
        self.ref?.child("PreConsultation").observe(.childAdded, with: { (snapshot) in
            
            //code to execute when a child is added under post
            //take value from the snapshot and added it to the postData array
            let question = snapshot.value as? String
            let qId = Int(snapshot.key)
            
            if let actualQuestion = question, let actualId = qId // check if the row is empty
            {
                //append data to postData array
                self.data.append(actualQuestion)
                self.id.append(actualId)
                
                
                //reload the table view
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
                self.num = 1
                print(actualId)
                print(actualQuestion)
                
                
                
            }
          
        })
        // Bounce back to the main thread to update the UI
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if num == 0
        {
            SVProgressHUD.show(withStatus: "Loading")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")
        
        
//        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
//        button.backgroundColor = UIColor.clear
//       
//        button.tag = id[indexPath.row]
//        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
      
        cell?.backgroundColor = .white
       // cell?.contentView.addSubview(button)
        cell?.textLabel?.text = data[indexPath.row]
        cell?.selectionStyle = .none
        cell?.tag = id[indexPath.row]
        
        
        return cell!
    }
    
    func buttonAction(sender: UIButton!) {
        print("Button tapped")
        print(sender.tag)
        sender.backgroundColor = .red
        sender.alpha = 0.5
        
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        let selectedCell:UITableViewCell =  tableView.cellForRow(at: indexPath)!
        
        
        if  selectedCell.backgroundColor == .white
        {
        selectedCell.backgroundColor = .green
        cellArray.append(selectedCell.tag)
        print(selectedCell.tag)
        }
        
        else{
            selectedCell.backgroundColor = .white
            if let index = cellArray.index(of: selectedCell.tag) {
                cellArray.remove(at: index)
            }
            
        }
        
            
        
    }
    
  
    @IBAction func nextBtn(_ sender: Any) {
        
//        let myVC = storyboard?.instantiateViewController(withIdentifier: "00") as! OtherInformationStep2ViewController
//        myVC.textView.text =
        self.performSegue(withIdentifier: "next1", sender: self)
        
    }
    

    
}
