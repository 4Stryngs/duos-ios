//
//  File.swift
//  Duos
//
//  Created by Jorge Tapia on 10/10/15.
//  Copyright © 2015 Jorge Tapia. All rights reserved.
//

import UIKit

class Card {

    var assetName: String
    var flipped: Bool
    
    init(assetName: String, flipped: Bool) {
        self.assetName = assetName
        self.flipped = flipped
    }
    
    class func randomCards(number: Int) -> [Card] {
        var cards = [Card]()
        
        for var i = 1; i <= 138; i++ {
            cards.append(Card(assetName: "\(i)card", flipped: false))
        }
        
        cards.shuffle()
        
        var firstHalfCards = Array(cards[0...number - 1])
        let secondHalfCards = Array(cards[0...number - 1])
        
        for card in secondHalfCards {
            firstHalfCards.append(card)
        }
        
        firstHalfCards.shuffle()
        return firstHalfCards
    }

}
