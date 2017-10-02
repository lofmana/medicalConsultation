//
//  RegisterViewController.swift
//  messagingapp
//
//  Created by Adam Tan on 14/6/17.
//  Copyright © 2017 ADAM TAN. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var addressText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        addressText.layer.borderWidth = 0.5
        addressText.layer.borderColor = borderColor.cgColor
        addressText.layer.cornerRadius = 5.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    @IBAction func segment2(_ sender: Any) {
        self.performSegue(withIdentifier: "login", sender: self)

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
