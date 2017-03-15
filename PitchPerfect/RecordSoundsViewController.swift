//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Christina Bharara on 3/12/17.
//  Copyright © 2017 cabhara. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {

    // MARK: - Properties
    var audioRecorder: AVAudioRecorder!
    
    // MARK: - IBOutlets
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    // MARK: - live cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIState(isRecording:false)
        stopRecordButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
    }

    // MARK: - IBActions
    @IBAction func recordAudio(_ sender: Any) {
        setUIState(isRecording:true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        setUIState(isRecording:false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: - helper methods
    func setUIState(isRecording:Bool)
    {
        recordingLabel.text = (isRecording) ? "Recording in progress" : "Tap to Record"
        stopRecordButton.isEnabled = isRecording
        recordButton.isEnabled = !isRecording
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

// MARK: - AVAudioRecorderDelegate
extension RecordSoundsViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else{
            //not successfull
            showAlert(Alerts.RecordingFailedTitle, message: "")
        }
    }
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

