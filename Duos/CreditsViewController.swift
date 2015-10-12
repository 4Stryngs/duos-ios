//
//  CreditsViewController.swift
//  Duos
//
//  Created by Jorge Tapia on 10/12/15.
//  Copyright © 2015 Jorge Tapia. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {
    
    @IBOutlet weak var creditsTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        creditsTextView.alpha = 0.0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        creditsTextView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: false)
        
        if creditsTextView.alpha == 0.0 {
            UIView.animateWithDuration(0.5) { () -> Void in
                self.creditsTextView.alpha = 1.0
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
