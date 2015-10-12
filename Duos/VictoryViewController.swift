//
//  VictoryViewController.swift
//  Duos
//
//  Created by Jorge Tapia on 10/11/15.
//  Copyright © 2015 Jorge Tapia. All rights reserved.
//

import UIKit

class VictoryViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    weak var delegate: GameViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLabel.text = delegate?.timeLabel.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func replayAction(sender: AnyObject) {
        delegate?.restarted = true
        delegate?.restartAction(self)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func highScoresAction(sender: AnyObject) {
        delegate?.audioManager.playButtonSound()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
