//
//  HighScore.swift
//  Duos
//
//  Created by Jorge Tapia on 10/11/15.
//  Copyright © 2015 Jorge Tapia. All rights reserved.
//

import UIKit
import CoreData

class HighScore: NSManagedObject {

    class func createNew(time: String?, date: NSDate?) -> HighScore? {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            let managedObjectContext = appDelegate.managedObjectContext
            
            let entity = NSEntityDescription.entityForName("HighScore", inManagedObjectContext: managedObjectContext)
            
            let newHighScore = HighScore(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
            newHighScore.time = time
            newHighScore.date = date
            
            return newHighScore
        }
        
        return nil
    }
    
    class func allScores() -> [AnyObject] {
        var highScores = [AnyObject]()
        
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            do {
                let managedObjectContext = appDelegate.managedObjectContext
                let entity = NSEntityDescription.entityForName("HighScore", inManagedObjectContext: managedObjectContext)
                
                let fetchRequest = NSFetchRequest()
                fetchRequest.entity = entity
                
                highScores = try managedObjectContext.executeFetchRequest(fetchRequest)
            } catch let error as NSError {
                NSLog("An error ocurred while fetching high scores: \(error.userInfo)")
            }
            
        }
        
        return highScores
    }
    
    class func reset() {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            let managedObjectContext = appDelegate.managedObjectContext
            
            let highScores = allScores()
            
            for score in highScores {
                managedObjectContext.deleteObject(score as! NSManagedObject)
            }
            
            appDelegate.saveContext()
        }
    }
}