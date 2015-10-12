//
//  GameViewController.swift
//  Duos
//
//  Created by Jorge Tapia on 10/9/15.
//  Copyright © 2015 Jorge Tapia. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var remainingLabel: UILabel!
    
    @IBOutlet weak var cardContainerView: UIView!
    @IBOutlet var cardImageViews: [UIImageView]!
    
    weak var flippedCard1: UIImageView?
    weak var flippedCard2: UIImageView?
    
    var audioManager = AudioManager(file: "Divertissement", type: "mp3")
    var muted = false
    
    let totalCards = UIDevice.currentDevice().userInterfaceIdiom == .Phone ? 10 : 15
    var remaining = UIDevice.currentDevice().userInterfaceIdiom == .Phone ? 10 : 15
    var timeInSeconds = 0
    var restarted = false
    
    var cards = Card.randomCards(UIDevice.currentDevice().userInterfaceIdiom == .Phone ? 10 : 15)
    
    
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        muteButton.setImage(UIImage(named: muted ? "mute" : "loud"), forState: .Normal)
        
        audioManager.audioPlayer?.volume = muted ? 0.0 : 1.0
        audioManager.tryPlayMusic()
        
        remainingLabel.text = "\(remaining) REMAINING"
        setupCardImageViews()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !restarted {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimeLabel", userInfo: nil, repeats: true)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        audioManager.audioPlayer?.stop()
        audioManager.playFlipSound()
        
        if timer.valid {
            timer.invalidate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - Actions
    
    @IBAction func muteAction(sender: AnyObject) {
        audioManager.audioPlayer?.volume = muted ? 1.0 : 0.0
        muted = audioManager.audioPlayer?.volume == 0.0 ? true : false
        
        muteButton.setImage(UIImage(named: muted ? "mute" : "loud"), forState: .Normal)
        audioManager.playButtonSound()
    }
    
    @IBAction func pauseAction(sender: AnyObject) {
        if timer.valid {
            timer.invalidate()
            pauseButton.setImage(UIImage(named: "play"), forState: .Normal)
            cardContainerView.userInteractionEnabled = false
        } else {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimeLabel", userInfo: nil, repeats: true)
            pauseButton.setImage(UIImage(named: "pause"), forState: .Normal)
            cardContainerView.userInteractionEnabled = true
        }
        
        audioManager.playButtonSound()
    }
    
    @IBAction func restartAction(sender: AnyObject) {
        restarted = true
        audioManager.playButtonSound()
        
        if flippedCard1 != nil {
            flipCard(flippedCard1, back: true)
        }
        
        if flippedCard2 != nil {
            flipCard(flippedCard1, back: true)
        }
        
        flippedCard1 = nil
        flippedCard2 = nil

        cards = Card.randomCards(totalCards)
        
        for var i = 0; i < cards.count; i++ {
            if cardImageViews[i].alpha > 0.0 {
                continue
            }
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.cardImageViews[i].alpha = 1.0
                self.flipCard(self.cardImageViews[i], back: true)
            })
            
        }
        
        remaining = totalCards
        remainingLabel.text = "\(totalCards) REMAINING"
        
        timeLabel.text = "00:00"
        timeInSeconds = 0
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimeLabel", userInfo: nil, repeats: true)
        
        audioManager.tryPlayMusic()
    }
    
    // MARK: - UI setup methods
    
    func setupCardImageViews() {
        var count = 1
        
        for cardImageView in cardImageViews {
            cardImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tappedCardAction:"))
            cardImageView.tag = count
            count++
        }
    }
    
    func tappedCardAction(sender: UITapGestureRecognizer) {
        if let card = sender.view as? UIImageView {
            if flippedCard1 == nil {
                flippedCard1 = card
                
                flipCard(flippedCard1, back: false)
                return
            }
            
            if flippedCard1 != nil && flippedCard2 == nil {
                flippedCard2 = card
                flipCard(flippedCard2, back: false)
                
                restartButton.enabled = false
                
                let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
                dispatch_after(dispatchTime, dispatch_get_main_queue(), { () -> Void in
                    let cardIndex1 = self.flippedCard1!.tag - 1
                    let cardIndex2 = self.flippedCard2!.tag - 1
                    
                    let cardAsset1 = self.cards[cardIndex1].assetName
                    let cardAsset2 = self.cards[cardIndex2].assetName
                    
                    if (cardAsset1 != cardAsset2) {
                        self.flipCard(self.flippedCard1, back: true)
                        self.flipCard(self.flippedCard2, back: true)
                        
                        self.cards[cardIndex1].flipped = false
                        self.cards[cardIndex2].flipped = false
                        
                        self.flippedCard1 = nil
                        self.flippedCard2 = nil
                        
                        self.audioManager.playWrongSound()
                    } else {
                        UIView.animateWithDuration(0.5, animations: { () -> Void in
                            self.flippedCard1?.alpha = 0.0
                            self.flippedCard2?.alpha = 0.0
                            }, completion: { (completed) -> Void in
                                if self.remaining == 0 {
                                    self.timer.invalidate()
                                    
                                    if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                                        HighScore.createNew(self.timeLabel.text, date: NSDate())
                                        appDelegate.saveContext()
                                    }
                                    
                                    self.performSegueWithIdentifier("victorySegue", sender: self)
                                    self.audioManager.playVictorySound()
                                }
                                
                                self.restartButton.enabled = true
                        })
                        
                        self.flippedCard1 = nil
                        self.flippedCard2 = nil
                        
                        self.remaining--
                        self.remainingLabel.text = "\(self.remaining) REMAINING"
                        
                        self.audioManager.playCorrectSound()
                    }
                    
                    self.restartButton.enabled = true
                })
            }
        }
    }
    
    private func flipCard(cardImageView: UIImageView!, back: Bool) {
        // let index = cardImageView.tag > cards.count ? cardImageView.tag - cards.count - 1 : cardImageView.tag - 1
        let index = cardImageView.tag - 1
        cards[index].flipped = true
        
        cardImageView.image = UIImage(named: back ? "button_bg" : cards[index].assetName)
        cardImageView.contentMode = back ? .ScaleToFill : .ScaleAspectFit
        cardImageView.userInteractionEnabled = back
        
        let transitionOption: UIViewAnimationOptions = back ? .TransitionFlipFromLeft : .TransitionFlipFromRight
        UIView.transitionWithView(cardImageView, duration: 0.5, options: transitionOption, animations: nil, completion: nil)
        
        audioManager.playFlipSound()
    }
    
    // MARK: - Timer handler
    
    func updateTimeLabel() {
        ++timeInSeconds
        
        var secondsString = String()
        var minutesString = String()
        
        var seconds = timeInSeconds % 60
        let minutes = timeInSeconds / 60
        
        if seconds > 59 {
            seconds = seconds - (seconds * 60)
        }
        
        // Format seconds
        if 0...9 ~= seconds {
            secondsString = "0\(seconds)"
        } else if 10...59 ~= seconds {
            secondsString = String(seconds)
        }
        
        // Format minutes
        if 0...9 ~= minutes {
            minutesString = "0\(minutes)"
        } else {
            minutesString = String(minutes)
        }
        
        timeLabel.text = "\(minutesString):\(secondsString)"
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "victorySegue" {
            let victoryViewController = segue.destinationViewController as! VictoryViewController
            victoryViewController.delegate = self
        }
    }
}
