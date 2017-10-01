//
//  loginViewController.swift
//  messagingapp
//
//  Created by Adam Tan on 1/6/17.
//  Copyright © 2017 CodeWithChris. All rights reserved.
//

import UIKit
import FirebaseAuth
import Locksmith
import LocalAuthentication


class loginViewController: UIViewController {

    
  
    @IBOutlet weak var emailtext: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var signInChanger: UISegmentedControl!
    
    @IBOutlet weak var switch1: UISwitch!

    @IBAction func loginButton(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailtext.text!, password: passwordText.text!) { (user, error) in
            if user != nil
            {
                var email = self.emailtext.text!
                var password = self.passwordText.text!
                
                if self.switch1.isOn == false
                {
                    email = ""
                    password = ""
                   
                }
                
              
                    
                
                
                do{
                    try Locksmith.updateData(data: ["email": email], forUserAccount: "account1")
                    try Locksmith.saveData(data: ["email": email], forUserAccount: "account1")
                    
                    }
                    
                catch{
                    
                    }
                
                
                do{
                    
                    
                    try Locksmith.updateData(data: ["Password": password], forUserAccount: "account")
                    try Locksmith.saveData(data: ["Password": password], forUserAccount: "account")
                    }
                    
                catch{
                    
                
                        }
                
                
                self.performSegue(withIdentifier: "home", sender: self)
 
            }
            
            else{
                
            }
        }
        
        
    }
    
    
    
    @IBAction func textchange(_ sender: Any) {
        emailtext.text = ""
        
    }
    @IBAction func passwordchange(_ sender: UITextField) {
        passwordText.text=""
        
    }
    
    
    
    
    
    @IBAction func rememberMe(_ sender: Any) {
        
        
    }
    
    
   
    @IBAction func segLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "register", sender: self)

    }
 
    
    
    @IBAction func touchID(_ sender: Any) {
        
        let authenticationContext = LAContext()
        var error: NSError?
        
        if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
            {
            //check if the user can auth this device
                authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please authenticate", reply: { (success , error) in
                    if success
                    {
                        //navigate to the sucess vc
                        self.performSegue(withIdentifier: "home", sender: self)
                        
                    }
                    else
                    {
                        if let error = error as NSError?
                        {
                            //display error of specific type
                            let message = self.errorMessgaeForLAErrorCode(errorCode: error.code)
                            self.showAlertViewAfterEvaluatingPolicyWithMessage(message: message)
                        }
                    }
                })
            }
        
        else{
            
            showAlertViewForNoBiometric()
            return
            }
        }
    
    
    func showAlertViewAfterEvaluatingPolicyWithMessage(message : String)
    {
        showAlertWithTitle(title: "Error", message: message)
    }
    
    
    
    func errorMessgaeForLAErrorCode(errorCode:Int) ->String
    {
        var message = ""
        
        switch errorCode {
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
        
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts"
            
        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not avaliable on this device"
            
        case LAError.userCancel.rawValue:
            message = "The user cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user choose to use the fallback"
            
            
        default:
            message = "Did not find any error"
        }
        
        return message
    }
    
    func navigateToAuthenticatedVC()
    {
        if let loggedInVC = storyboard?.instantiateViewController(withIdentifier: "home")
        {
            self.navigationController?.pushViewController(loggedInVC, animated: true)
        }
    }
    
    func showAlertViewForNoBiometric(){
        showAlertWithTitle(title:"Error" , message: "This device dont not have touch ID")
    }
    
    
    func showAlertWithTitle(title : String , message : String){
        let alertVC = UIAlertController(title: title , message:message , preferredStyle: .alert)
        let okAction = UIAlertAction(title:"ok" , style: .default , handler: nil)
        
        alertVC.addAction(okAction)
        self.present(alertVC , animated: true , completion: nil)
        
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        let dictionary1 = Locksmith.loadDataForUserAccount(userAccount: "account1")
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: "account")
        
        
        
        let token1 = dictionary1?["email"] as? String
        let token = dictionary?["Password"] as? String
        
        print(token1)
        print(token)
        emailtext.text = token1
        passwordText.text = token
        

        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
   
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        
       
        view.addGestureRecognizer(tap)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
