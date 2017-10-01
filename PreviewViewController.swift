//
//  PreviewViewController.swift
//  Print2PDF
//
//  Created by Gabriel Theodoropoulos on 14/06/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit
import MessageUI
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth


class PreviewViewController: UIViewController {
    
    let databaseRef = Database.database().reference(fromURL : "https://medicalconsultation.firebaseio.com")
    
    @IBOutlet weak var webPreview: UIWebView!
    
    var invoiceInfo: [String: AnyObject]!
    
    var invoiceComposer: InvoiceComposer!
    
    var HTMLContent: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        createInvoiceAsHTML()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: IBAction Methods
    
    
    @IBAction func exportToPDF(_ sender: AnyObject) {
        invoiceComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
        showOptionsAlert()
    }
    
    
    @IBAction func PDFbtn(_ sender: Any) {
        invoiceComposer.exportHTMLContentToPDF(HTMLContent: HTMLContent)
        showOptionsAlert()
    }
    
    
    func createInvoiceAsHTML() {
        invoiceComposer = InvoiceComposer()
        if let invoiceHTML = invoiceComposer.renderInvoice(invoiceNumber: invoiceInfo["invoiceNumber"] as! String,
                                                           invoiceDate: invoiceInfo["invoiceDate"] as! String,
                                                           recipientInfo: invoiceInfo["recipientInfo"] as! String,
                                                           items: invoiceInfo["items"] as! [[String: String]],
                                                           totalAmount: invoiceInfo["totalAmount"] as! String) {
            
            webPreview.loadHTMLString(invoiceHTML, baseURL: NSURL(string: invoiceComposer.pathToInvoiceHTMLTemplate!)! as URL)
            HTMLContent = invoiceHTML
        }
    }
    
    
    
    func showOptionsAlert() {
        let alertController = UIAlertController(title: "Yeah!", message: "Your invoice has been successfully printed to a PDF file.\n\nWhat do you want to do now?", preferredStyle: UIAlertControllerStyle.alert)
        
        let actionPreview = UIAlertAction(title: "Preview it", style: UIAlertActionStyle.default) { (action) in
            if let filename = self.invoiceComposer.pdfFilename, let url = URL(string: filename) {
                let request = URLRequest(url: url)
                self.webPreview.loadRequest(request)
                
            }
        }
        
        let actionEmail = UIAlertAction(title: "Send by Email", style: UIAlertActionStyle.default) { (action) in
            DispatchQueue.main.async {
                self.sendEmail()
            }
        }
        
        let actionNothing = UIAlertAction(title: "Upload", style: UIAlertActionStyle.default) { (action) in
            print("haha")
            self.uploadFile()
        }
        
        alertController.addAction(actionPreview)
        alertController.addAction(actionEmail)
        alertController.addAction(actionNothing)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.setSubject("Invoice")
            mailComposeViewController.addAttachmentData(NSData(contentsOfFile: invoiceComposer.pdfFilename)! as Data, mimeType: "application/pdf", fileName: "Invoice")
            present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    func uploadFile(){
        
        
        
        
        //     print("\(invoiceComposer.pdfFilename)!")
        
        print("hahah")
        //        // Points to the root reference
        
        let userID = Auth.auth().currentUser?.uid
        databaseRef.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let nric = value?["NRIC"] as? String ?? ""
            
            ///////////// upload starts here /////////////////////////////
            
            let filename = "\(self.invoiceComposer.pdfFilename!)"
            
            
            let storageRef = Storage.storage().reference()
            
            //let filepath = url
            print("test")
            
            print(filename)
            // File located on disk
            //let localFile = URL(string: "\(filepath)")!
            let localFile = URL(string: "file://\(filename)")!
            
            
            
            // Create a reference to the file you want to upload
            let riversRef = storageRef.child("Consultation/\(nric)/\(self.invoiceComposer.invoiceNumber!)")
            
            // Upload the file to the path "images/rivers.jpg"
            let uploadTask = riversRef.putFile(from: localFile, metadata: nil) { metadata, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                }
                else
                {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    let downloadURL = metadata!.downloadURL()
                }
                
            }
            
            ////////////////upload ends here////////////////
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        
        
    }
}
