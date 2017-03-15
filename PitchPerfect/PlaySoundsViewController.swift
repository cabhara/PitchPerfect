//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Christina Bharara on 3/12/17.
//  Copyright © 2017 cabhara. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var OuterStackView: UIStackView!
    @IBOutlet weak var innerStackView1: UIStackView!
    @IBOutlet weak var innerStackView2: UIStackView!
    @IBOutlet weak var innerStackView3: UIStackView!
    
    // MARK: - Properties
    var recordedAudioURL:URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    //MARK: - IBActions
    @IBAction func playSoundForButton(_ sender: UIButton){
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton){
        stopAudio()
    }
    
    //MARK: - StackView Layout helper
    func setInnerStackViewsAxis(axisStyle: UILayoutConstraintAxis)  {
        self.innerStackView1.axis = axisStyle
        self.innerStackView2.axis = axisStyle
        self.innerStackView3.axis = axisStyle
    }

    // override this function to make sure when rotated to landscape, the buttons are not squeezed
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) -> Void in
            self.setCorrectOrientation()
        }, completion: nil)
    }
    
    func setCorrectOrientation(){
        let orientation = UIApplication.shared.statusBarOrientation
        
        if orientation.isPortrait{
            self.OuterStackView.axis = .vertical
            self.setInnerStackViewsAxis(axisStyle: .horizontal)
        } else {
            self.OuterStackView.axis = .horizontal
            self.setInnerStackViewsAxis(axisStyle: .vertical)
        }
    }
    
    //MARK: - Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setCorrectOrientation()
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }    
}
