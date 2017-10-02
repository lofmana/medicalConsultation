//
//  VoiceHomeViewController.swift
//  medicalConsultation
//
//  Created by Adam Tan on 23/6/17.
//  Copyright © 2017 Adam Tan. All rights reserved.
//

import UIKit
import SwiftySound
import Speech
import ApiAI
import AVFoundation
import FirebaseDatabase
import FirebaseAuth

var symtomMain = ""
var dateMain = ""
var bodypartMain = ""
var receive = false

class VoiceHomeViewController: UIViewController , SFSpeechRecognizerDelegate{
    
    @IBOutlet weak var symtomLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodypartLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
 
    
    
    var audioPlayer = AVAudioPlayer()
    //For our device to speak
    let speechSynthesizer = AVSpeechSynthesizer()
    
    @IBOutlet weak var textView: UITextView!
    
    
    @IBOutlet weak var microphoneButton: UIButton!
    
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-SG"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording = false
    var audioSession:AVAudioSession = AVAudioSession.sharedInstance()
    let audioEngine = AVAudioEngine()
    
    var postData = [String]()
    var postData2 = [String]()
    var ref : DatabaseReference?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        //        do {
        //            try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        //        }
        //
        //        catch let error as NSError {
        //                       print("audioSession error: \(error.localizedDescription)")
        //                   }
        //
        
        
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        
        
        
        self.ref = Database.database().reference()
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
            
            
            
        })
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(false)
        do {
            try audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
            try audioSession.setActive(true)
            
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func microphoneTapped(_ sender: Any) {
        
        
        //Sound.play(file: "siriStart.wav")
        
        
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource:"siriStart", ofType:"wav")!))
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
        }
            
            
        catch
        {
            print(error)
        }
        
        
        let when = DispatchTime.now() + 0.3 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.audioPlayer.stop()
            if self.isRecording == true {
                self.statusLabel.text = "Press again to restart"
                
                self.recognitionTask?.cancel()
                self.isRecording = false
                self.microphoneButton.backgroundColor = UIColor.gray
                let request = ApiAI.shared().textRequest()
                if let text = self.textView.text, text != "" {
                    request?.query = text
                } else {
                    return
                }
                request?.setMappedCompletionBlockSuccess({ (request , response) in
                    let response = response as! AIResponse
                    
                    if let parameters = response.result.parameters as? [String : AIResponseParameter]
                    {
                        
                        
                        
                        if let symtoms = parameters["symtoms"]?.stringValue
                        {
                            self.symtomLabel.text = symtoms
                            symtomMain = symtoms
                            
                        }
                        
                        if let date = parameters["dates"]?.stringValue
                        {
                            self.dateLabel.text = date
                            dateMain = date
                        }
                        
                        if let bodyparts = parameters["bodyparts"]?.stringValue
                        {
                            self.bodypartLabel.text = bodyparts
                            bodypartMain = bodyparts
                        }
                        
                        receive = true
                    }
                    
                    if let textResponse = response.result.fulfillment.speech as? String
                    {
                        self.speak(text: textResponse)
                        self.textView.text = "\(textResponse)"
                    }
                    
                    if self.textView.text == ""
                    {
                        self.textView.text = "Can you please say that again?"
                        self.speak(text: self.textView.text)
                    }
                    
                    
                }, failure: {(request , error) in
                    
                    print(error ?? "error")
                })
                
                ApiAI.shared().enqueue(request)
                
            }
                
            else {
                self.statusLabel.text = "Press again to stop"
                self.textView.text = "I'm listening"
                self.audioEngine.reset()
                self.recordAndRecognizeSpeech()
                self.isRecording = true
                self.microphoneButton.backgroundColor = UIColor.red
                
                
                
                
            }
        }
        
        
        
    }
    
    
    func speak(text: String) {
        
        
        
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(speechUtterance)
        
        
    }
    
    
    func recordAndRecognizeSpeech() {
        
        
        guard let node = audioEngine.inputNode else { return }
        
        let recordingFormat = node.outputFormat(forBus: 0)
        node.removeTap(onBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.request.append(buffer)
            
            
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            self.sendAlert(message: "There has been an audio engine error.")
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            self.sendAlert(message: "Speech recognition is not supported for your current locale.")
            return
        }
        if !myRecognizer.isAvailable {
            self.sendAlert(message: "Speech recognition is not currently available. Check back at a later time.")
            // Recognizer is not available right now
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                
                let bestString = result.bestTranscription.formattedString
                self.textView.text = bestString
                
                
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = bestString.substring(from: indexTo)
                }
                
            }
        })
        
    }
    
    func sendAlert(message: String) {
        let alert = UIAlertController(title: "Speech Recognizer Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func nextBtn(_ sender: Any) {
        if (receive == true)
        {
        self.performSegue(withIdentifier: "postConsultation", sender: self)
        }
        else{
            print("please try again")
        }
    }
    
}
