//
//  MainViewController.swift
//  medicalConsultation
//
//  Created by Adam Tan on 20/6/17.
//  Copyright © 2017 Adam Tan. All rights reserved.
//

import UIKit

import FirebaseDatabase
import FirebaseAuth
import ApiAI
import AVFoundation
import Speech
import SwiftySound

class MainViewController: UIViewController , SFSpeechRecognizerDelegate {

    ///////
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))  //1
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    //////
   
    @IBOutlet weak var textView1: UITextView!
    
    @IBOutlet weak var viewColor: UIView!
    
    @IBOutlet weak var tfInput: UITextField!
    
    @IBOutlet weak var microphoneButton: UIButton!
    
    //this is for mic
     let speechSynthesizer = AVSpeechSynthesizer()
    //
    
    
   
    
  
    
    var postData = [String]()
    var postData2 = [String]()
    var ref : DatabaseReference?
    var databaseHandle : DatabaseHandle?
     var newItems = [DataSnapshot]()
   
    
    
    
    
    ////////////////////////////////////view didload////////////
    override func viewDidLoad() {
        
        
        Sound.enabled = true
        super.viewDidLoad()
        self.ref = Database.database().reference()
        
       
       
//        self.ref?.child("Disease").child("D1").observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//       
//            let value = snapshot.value as? [String: AnyObject]
//            
//            let test = value?["sym1"]!
//            
//            
//            print(test!)
//
//            self.textView1.text = snapshot.value as? String        // ...
//        }) { (error) in
//            print(error.localizedDescription)
//        }
        
        
        
        
        self.ref?.child("Disease").child("D1").observe(.childAdded, with: { (snapshot) in
            
            //code to execute when a child is added under post
            //take value from the snapshot and added it to the postData array
            let post = snapshot.value as? String
            
            if let actualpost = post // check if the row is empty
            {
                //append data to postData array
                self.postData.append(actualpost)
                 self.postData2 += [actualpost]
             
                
                
            }
            
             print("\(self.postData[0])")
        })
        
      
      
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        
        
        view.addGestureRecognizer(tap)
        
        
        
        ////start of mic
        microphoneButton.isEnabled = false  //2
        
        speechRecognizer?.delegate = self  //3
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
        ///end of mic
        
        
    }
    
    ///////////end of view didload/////////////////////////

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Device speak
    func speak(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US") 
        speechSynthesizer.speak(speechUtterance)
    }
    
    
    
    //Animation with color change on UIView
    
    func changeViewColor(color: UIColor) {
        viewColor.alpha = 0
        viewColor.backgroundColor = color
        UIView.animate(withDuration: 1, animations: {
            self.viewColor.alpha = 1
        }, completion: nil)
    }
    

    @IBAction func next1(_ sender: Any) {
        self.performSegue(withIdentifier: "next1", sender: self)

        
    }
    
    
    
    @IBAction func recordBtn(_ sender: Any) {
        
        if audioEngine.isRunning {
       
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
            microphoneButton.setTitle("Start Recording", for: .normal)
            
        } else {
            
            Sound.play(file: "siriStart.m4a")
            print("hhhhhhhh")
            startRecording()
            microphoneButton.setTitle("Stop Recording", for: .normal)
        }
    }
    
    
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.textView1.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        textView1.text = "Say something, I'm listening!"
        
    }
    
    
    
    @IBAction func btnSendDidTouch(_ sender: Any) {
        let request = ApiAI.shared().textRequest()
        if let text = self.tfInput.text, text != "" {
            request?.query = text
        } else {
            return
        }
        
        
        request?.setMappedCompletionBlockSuccess({ (request , response) in
            let response = response as! AIResponse
            
            print(" hahahahahahahahahahahahahahah")
            
            // if (response.result.action) == "change.color"
            
            // {
            
            if let parameters = response.result.parameters as? [String : AIResponseParameter]
            {
                
                
                
                if let color = parameters["color"]?.stringValue
                {
                    
                    switch color {
                        
                    case "red" :
                        self.changeViewColor(color: UIColor.red)
                    case "yellow" :
                        self.changeViewColor(color: UIColor.yellow)
                    default :
                        self.changeViewColor(color: UIColor.green)
                        
                    }
                    
                    
                }
                
            }
            
            
            //}
            
            //else{
            
            // self.changeViewColor(color: UIColor.black)
            // }
            
            if let textResponse = response.result.fulfillment.speech as? String
            {
                self.speak(text: textResponse)
                self.textView1.text = "\(textResponse)"
            }
            
            
        }, failure: {(request , error) in
            
            print(error ?? "error")
        })
        
        ApiAI.shared().enqueue(request)
        tfInput.text = ""
        
        
    }
    
    
   
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    


}

