//
//  Array+Extensions.swift
//  Duos
//
//  Created by Jorge Tapia on 10/9/15.
//  Copyright © 2015 Jorge Tapia. All rights reserved.
//

import Foundation

extension Array {
    
    mutating func shuffle() {
        // Fisher-Yates array shuffling algorithm
        srandom(UInt32(time(nil)))
        
        if self.count < 2 {
            return
        }
        
        for var i = 0, count = self.count; i < count; i++ {
            let nElements = count - i
            let n = (random() % nElements) + i
            
            guard i != n else {
                continue
            }
            
            swap(&self[i], &self[n])
        }
    }

}
