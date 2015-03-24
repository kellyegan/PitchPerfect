//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Kelly Egan on 3/9/15.
//  Copyright (c) 2015 Kelly Egan. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingStatus: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        pauseButton.hidden = true
        
        recordingStatus.textColor = UIColor( white: 1.0, alpha: 1.0)
        recordingStatus.text = "Tap to record"
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        println("Recording")
        recordingStatus.textColor = UIColor(red: 0.9, green: 0.0, blue: 0.0, alpha: 1.0)
        recordingStatus.text = "Recording"

        recordButton.enabled = false
        stopButton.hidden = false
        pauseButton.hidden = false
    }

    @IBAction func stopRecord(sender: UIButton) {
        //Stop recording user audio
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
        println("Recording stopped")
        
        recordingStatus.textColor = UIColor( white: 1.0, alpha: 1.0)
        recordingStatus.text = "Finishing recording"
        
        stopButton.hidden = true
    }
    
    @IBAction func pauseRecord(sender: UIButton) {
        if( audioRecorder.recording ) {
            audioRecorder.pause()
            recordingStatus.text = "Paused"
        } else {
            audioRecorder.record()
            recordingStatus.text = "Recording"
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if( flag ){
            //Save the recorded audio
            recordedAudio = RecordedAudio(filePath: recorder.url)

            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording did not finished successfully.")
            recordingStatus.text = "Tap to record"
        }
        
        recordButton.enabled = true
        stopButton.hidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if( segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            
            playSoundsVC.receivedAudio = data
        }
    }
}

