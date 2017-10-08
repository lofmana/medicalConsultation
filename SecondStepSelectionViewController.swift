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



class SecondStepSelectionViewController: UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var ref : DatabaseReference?
    var databaseHandle : DatabaseHandle?
    var data = [String]()
    var id = [Int]()
    var cellArray = [String]()
    var higestArray = [String]()
    var highest = ""
    
    var data2 = [String]()
    var id2 = [Int]()
    var cellArray2 = [String]()
    
    var data3 = [String]()
    var id3 = [Int]()
    var cellArray3 = [String]()
    
    var num = 0
    var counts: [String: Int] = [:]
    var counts2: [String: Int] = [:]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data3.count
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
        cell?.textLabel?.text = data3[indexPath.row]
        cell?.selectionStyle = .none
        cell?.tag = Int(id3[indexPath.row])
        
        
        
        
        
        return cell!
    }
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        for item in finalArrayId {
            
            
            
            for var i in 1...3
            {
                
                
                let ref = Database.database().reference().child("Disease").queryOrdered(byChild: "sym\(String(i))").queryEqual(toValue : "\(String(item))" )
                
                ref.observe(.value, with:{ (snapshot: DataSnapshot) in
                    for snap in snapshot.children {
                        print((snap as! DataSnapshot).key)
                        
                        self.cellArray.append(String((snap as! DataSnapshot).key))
                     
                        
                    }
                })
                
            }
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            // Put your code which should be executed with a delay here
            self.cellArray.forEach {
                
                self.counts[$0] = (self.counts[$0] ?? 0) + 1
                
            }
            if let (value, count) = self.counts.max(by: {$0.1 < $1.1}) {
                print("\(value) occurs \(count) times")
                self.higestArray.append(value)
                self.highest = value
            }
            
            for item in self.cellArray {
                self.counts2[item] = (self.counts2[item] ?? 0) + 1
            }
            print(self.counts2)
            
            for value in self.cellArray {
                let index = self.counts2[value] ?? 0
                self.counts2[value] = index + 1
            }
            
            let result = self.counts2.sorted{$0.1 > $1.1}.map{$0.0}
            print("result : \(result)")
            
            for (key, value) in self.counts2 {
                print("\(key) occurs \(value) time(s)")
            }

            self.tableView.delegate = self
            self.tableView.dataSource = self

            self.ref = Database.database().reference()
            
            
            print(self.higestArray[0])
            self.ref?.child("Disease").child("\(self.highest)").observe(.childAdded, with: { (snapshot) in

                //code to execute when a child is added under post
                //take value from the snapshot and added it to the postData array
                let temp = snapshot.value as? String
                let qId = Int(snapshot.key)



                //append data to postData array
                self.data2.append(temp!)
                self.id2.append(Int(temp!)!)
               

            })
            
            
            
            
                  DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    
                
                    
                    
                    let set1 = Set(self.id2)
                    let set2 = Set(finalArrayId)
                    
                    let filter = Array(set1.subtracting(set2))
                    print(filter)
                   
           
                  
                self.ref?.child("Symtoms").observe(.childAdded, with: { (snapshot) in
                    
                    //code to execute when a child is added under post
                    //take value from the snapshot and added it to the postData array
                    let temp = snapshot.value as? String
                    let qId = Int(snapshot.key)
                    
                  for item in filter
                  {
                            if (qId == item)
                            {
                        //append data to postData array
                    self.data3.append(temp!)
                    self.id3.append(qId!)
                    }
                    
                    }
                        
                        
                    
                    
                        //reload the table view
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                        self.num = 1
     
                })
                    
        })
            

        })
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        
     
     getMoreSymtoms()
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell:UITableViewCell =  tableView.cellForRow(at: indexPath)!
        
        
        if  selectedCell.backgroundColor == .white
        {
            selectedCell.backgroundColor = .green
           // id3.append(selectedCell.tag)
          finalArray.append((selectedCell.textLabel?.text)!)
            print(selectedCell.tag)
        }
            
        else{
            selectedCell.backgroundColor = .white
            if let index = id3.index(of: selectedCell.tag) {
              //  cellArray3.remove(at: index)
                finalArray.remove(at: index)
            }
            
        }
        
        
        
    }
    
    
    func getMoreSymtoms() -> Void {
        
        for item in finalArray
        {
            print(item)
        }
        
    }
    
}
