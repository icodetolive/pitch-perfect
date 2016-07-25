//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Sugandha Naolekar on 6/11/16.
//  Copyright © 2016 icode. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    //the above line means, the class RecordSoundsViewController is inherited from a super class UIViewController. In swift, only one superclass can be inherited. But a class can conform to many protocol classes. In this case, it conforms to the AVAudioRecorderDelegate. Which means, the RecordSoundsViewController acts as a delegate of AvAudioRecorder. Once the recording task is finished by the AVAudioRecorder, it informs the RecordSoundsViewController about it. Hence, AVAudioRecorder acts just as a tool to record videos. And thereby, both the classes here are loosely coupled and yet can communicate with each other wihtout knowing each other's details. 

    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var recordingButton: UIButton!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.enabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func recordAudio(sender: AnyObject) {
        
        configureButtonStates(sender)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(sender: AnyObject) {
        
        configureButtonStates(sender)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func configureButtonStates(sender: AnyObject) {
        
        recordingLabel.text = sender.tag == 0 ? "Recording in progress" : "Tap to record"
        recordingButton.enabled = !recordingButton.enabled
        stopRecordingButton.enabled = !stopRecordingButton.enabled
    }
    
    //this function will call the stopRecording segue to move to the view linked to it.
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        print("AVAudioRecorder finished saving recording")
        
        //the flag determines whether the saving of the reocrding was successful or not. If yes, inform the seqgue to send the recoded file's url to the next viewController linked to it.
        
        if(flag) {
            performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        }
        else {
            print("Saviing of the recording failed...!")
        }
    }
    
    //This function is called before the storyboard calls the segue which in turn displays the viewcontroller linked to it.
    // It sends the recorded audio url to the view connected through the segue
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

