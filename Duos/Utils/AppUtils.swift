//
//  AppUtils.swift
//  Duos
//
//  Created by Jorge Tapia on 10/14/15.
//  Copyright © 2015 Jorge Tapia. All rights reserved.
//

import Foundation

class AppUtils {

    class func formatTimeInSeconds(time: Int) -> String {
        let totalTime = abs(time)
        
        var secondsString = String()
        var minutesString = String()
        
        var seconds = totalTime % 60
        let minutes = totalTime / 60
        
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
        
        return "\(minutesString):\(secondsString)"
    }
    
}
