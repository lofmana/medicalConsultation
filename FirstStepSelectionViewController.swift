//
//  FirstStepSelectionViewController.swift
//  medicalConsultation
//
//  Created by Adam Tan on 28/9/17.
//  Copyright © 2017 Adam Tan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SVProgressHUD
import FirebaseAuth

class FirstStepSelectionViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    
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
        
        self.ref?.child("Symtoms").observe(.childAdded, with: { (snapshot) in
            
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "symtomsCell")
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
    

    @IBAction func nextBtn(_ sender: Any) {
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
    
    
    
}
