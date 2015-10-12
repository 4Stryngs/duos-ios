//
//  AudioManager.swift
//  Duos
//
//  Created by Jorge Tapia on 10/9/15.
//  Copyright © 2015 Jorge Tapia. All rights reserved.
//

import AVFoundation

class AudioManager: NSObject {
    
    var audioSession: AVAudioSession?
    var audioPlayer: AVAudioPlayer?
    
    var musicPlaying = false
    var musicInterrupted = false
    
    var buttonSound: SystemSoundID = 0
    var flipSound: SystemSoundID = 0
    var correctSound: SystemSoundID = 0
    var wrongSound: SystemSoundID = 0
    var victorySound: SystemSoundID = 0
    
    init(file:String?, type:String?) {
        super.init()
        
        configureAudioSession()
        configureAudioPlayer(file, type: type)
        configureFlipSound("240777__f4ngy__dealing-card", type: "wav")
        configureWrongSound("131657__bertrof__game-sound-wrong", type: "wav")
        configureCorrectSound("131660__bertrof__game-sound-correct", type: "wav")
        configureVictorySound("270402__littlerobotsoundfactory__jingle-win-00", type: "wav")
        configureButtonSound("177156__abstudios__water-drop", type: "mp3")
    }
    
    func tryPlayMusic() {
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
        musicPlaying = true
    }
    
    func playFlipSound() {
        AudioServicesPlaySystemSound(flipSound)
    }
    
    func playWrongSound() {
        AudioServicesPlaySystemSound(wrongSound)
    }
    
    func playCorrectSound() {
        AudioServicesPlaySystemSound(correctSound)
    }
    
    func playVictorySound() {
        AudioServicesPlaySystemSound(victorySound)
    }
    
    func playButtonSound() {
        AudioServicesPlaySystemSound(buttonSound)
    }
    
    // MARK: - Audio session and player setup
    
    private func configureAudioSession() {
        audioSession = AVAudioSession.sharedInstance()
        
        if let audioSession = audioSession {
            if audioSession.otherAudioPlaying {
                do {
                    try audioSession.setCategory(AVAudioSessionCategorySoloAmbient)
                    musicPlaying = false
                } catch let error as NSError {
                    NSLog("Error setting category: \(error.userInfo)")
                }
            } else {
                do {
                    try audioSession.setCategory(AVAudioSessionCategoryAmbient)
                    musicPlaying = false
                } catch let error as NSError {
                    NSLog("Error setting category: \(error.userInfo)")
                }
            }
        }
    }
    
    private func configureAudioPlayer(file: String?, type: String?) {
        let backgroundMusicPath = NSBundle.mainBundle().pathForResource(file, ofType: type)
        let backgroundMusicURL = NSURL(fileURLWithPath: backgroundMusicPath!)
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicURL)
            
            if let audioPlayer = audioPlayer {
                audioPlayer.delegate = self
                audioPlayer.numberOfLoops = -1
            }
        } catch let error as NSError {
            NSLog("Error when trying to setup the audio player: \(error.userInfo)")
        }
    }
    
    // MARK: - System sounds configuration
    
    private func configureFlipSound(file: String?, type: String?) {
        let buttonSoundPath = NSBundle.mainBundle().pathForResource(file, ofType: type)
        let buttonSoundURL = NSURL(fileURLWithPath: buttonSoundPath!)
        
        AudioServicesCreateSystemSoundID(buttonSoundURL, &flipSound)
    }
    
    private func configureWrongSound(file: String?, type: String?) {
        let buttonSoundPath = NSBundle.mainBundle().pathForResource(file, ofType: type)
        let buttonSoundURL = NSURL(fileURLWithPath: buttonSoundPath!)
        
        AudioServicesCreateSystemSoundID(buttonSoundURL, &wrongSound)
    }
    
    private func configureCorrectSound(file: String?, type: String?) {
        let buttonSoundPath = NSBundle.mainBundle().pathForResource(file, ofType: type)
        let buttonSoundURL = NSURL(fileURLWithPath: buttonSoundPath!)
        
        AudioServicesCreateSystemSoundID(buttonSoundURL, &correctSound)
    }
    
    private func configureVictorySound(file: String?, type: String?) {
        let buttonSoundPath = NSBundle.mainBundle().pathForResource(file, ofType: type)
        let buttonSoundURL = NSURL(fileURLWithPath: buttonSoundPath!)
        
        AudioServicesCreateSystemSoundID(buttonSoundURL, &victorySound)
    }
    
    private func configureButtonSound(file: String?, type: String?) {
        let buttonSoundPath = NSBundle.mainBundle().pathForResource(file, ofType: type)
        let buttonSoundURL = NSURL(fileURLWithPath: buttonSoundPath!)
        
        AudioServicesCreateSystemSoundID(buttonSoundURL, &buttonSound)
    }

}

// MARK: - Audio player delegate

extension AudioManager: AVAudioPlayerDelegate {

    func audioPlayerBeginInterruption(player: AVAudioPlayer) {
        musicInterrupted = true
        musicPlaying = false
    }
    
    func audioPlayerEndInterruption(player: AVAudioPlayer) {
        tryPlayMusic()
        musicInterrupted = false
    }
    
}
