//
//  MenuViewController.swift
//  Duos
//
//  Created by Jorge Tapia on 10/9/15.
//  Copyright © 2015 Jorge Tapia. All rights reserved.
//

import UIKit
import Social

class MenuViewController: UIViewController {
    
    @IBOutlet weak var muteButton: UIButton!
    
    var audioManager = AudioManager(file: "Gymnopedie_No_2", type: "mp3")
    var muted = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioManager.tryPlayMusic()
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
    
    @IBAction func facebookAction(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let facebookController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookController.completionHandler = { (result: SLComposeViewControllerResult) -> Void in
                facebookController.dismissViewControllerAnimated(true, completion: nil)
            }
            
            // URLs will change later, now point to one of my apps in the App Store for the purpose of functionality
            facebookController.addURL(NSURL(string: "https://itunes.apple.com/us/app/duos-card-matching-game/id1049082793?ls=1&mt=8"))
            
            presentViewController(facebookController, animated: true, completion: nil)
        } else {
            let alerController = UIAlertController(title: "Duos", message: "You are not signed in with Facebook. Please go to Settings, select the Facebook option and sign in with your account.", preferredStyle: .Alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .Cancel, handler: { (action) -> Void in
                if let settingsAppURL = NSURL(string: UIApplicationOpenSettingsURLString) {
                    if UIApplication.sharedApplication().canOpenURL(settingsAppURL) {
                        UIApplication.sharedApplication().openURL(settingsAppURL)
                    }
                }
            })
            
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
            
            alerController.addAction(settingsAction)
            alerController.addAction(dismissAction)
            
            presentViewController(alerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func twitterAction(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let twitterController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            twitterController.completionHandler = { (result: SLComposeViewControllerResult) -> Void in
                twitterController.dismissViewControllerAnimated(true, completion: nil)
            }
            
            twitterController.setInitialText("Having fun matching cards and training my #memory with #Duos, by @itsProf. Available on the App Store.")
            
            // URLs will change later, now point to one of my apps in the App Store for the purpose of functionality
            twitterController.addURL(NSURL(string: "https://itunes.apple.com/us/app/duos-card-matching-game/id1049082793?ls=1&mt=8"))
            
            presentViewController(twitterController, animated: true, completion: nil)
        } else {
            let alerController = UIAlertController(title: "Duos", message: "You are not signed in with Twitter. Please go to Settings, select the Twitter option and sign in with your account.", preferredStyle: .Alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .Cancel, handler: { (action) -> Void in
                if let settingsAppURL = NSURL(string: UIApplicationOpenSettingsURLString) {
                    if UIApplication.sharedApplication().canOpenURL(settingsAppURL) {
                        UIApplication.sharedApplication().openURL(settingsAppURL)
                    }
                }
            })
            
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
            
            alerController.addAction(settingsAction)
            alerController.addAction(dismissAction)
            
            presentViewController(alerController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gameSegue" {
            audioManager.audioPlayer?.stop()
            audioManager.audioPlayer?.currentTime = 0.0
            audioManager.playFlipSound()
            
            (segue.destinationViewController as! GameViewController).muted = muted
        } else {
            audioManager.playButtonSound()
        }
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        if segue.sourceViewController is GameViewController {
            let gameViewController = segue.sourceViewController as! GameViewController
            muted = gameViewController.muted
            
            audioManager.audioPlayer?.volume = muted ? 0.0 : 1.0
            muteButton.setImage(UIImage(named: muted ? "mute" : "loud"), forState: .Normal)
        }
        
        audioManager.audioPlayer?.play()
    }

}

