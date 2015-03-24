//
//  PlayAudioViewController.swift
//  PitchPerfect
//
//  Created by Kelly Egan on 3/11/15.
//  Copyright (c) 2015 Kelly Egan. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    var audioPlayer : AVAudioPlayer!
    var receivedAudio : RecordedAudio!
    var audioEngine : AVAudioEngine!
    var audioFile : AVAudioFile!
    var audioSession : AVAudioSession!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true

        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        // Allow audio to play through speaker on phone
        audioSession = AVAudioSession.sharedInstance()
        var error: NSError?
        audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, error: &error)
        audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: &error)
        audioSession.setActive(true, error: &error)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playAudioSlow(sender: UIButton) {
        playAudio(0.5)
        
    }

    @IBAction func playAudioFast(sender: UIButton) {
        playAudio(1.5)
    }
    
    @IBAction func playAudioChipmunk(sender: UIButton) {
        playAudioWithVariablePitch( 1000 )
    }
    
    @IBAction func playAudioDarthvader(sender: UIButton) {
        playAudioWithVariablePitch( -1000 )
    }
    
    func playAudioWithVariablePitch( pitch: Float ) {
        stopAudio()
        
        var playerNode = AVAudioPlayerNode()
        var timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        
        audioEngine.attachNode(playerNode)
        audioEngine.attachNode(timePitch)
        
        audioEngine.connect(playerNode, to: timePitch, format: audioFile.processingFormat)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: audioFile.processingFormat)
        
        playerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        playerNode.play()
    }
    
    
    @IBAction func stopAudioAll(sender: UIButton) {
        stopAudio()
    }
    
    func stopAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudio( rate: Float ) {
        stopAudio()
        
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
        audioPlayer.play()
    }
}
