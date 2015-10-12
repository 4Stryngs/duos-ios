//
//  HighScore+CoreDataProperties.swift
//  Duos
//
//  Created by Jorge Tapia on 10/11/15.
//  Copyright © 2015 Jorge Tapia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension HighScore {

    @NSManaged var date: NSDate?
    @NSManaged var time: String?

}
