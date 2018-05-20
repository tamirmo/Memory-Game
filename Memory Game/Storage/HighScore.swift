//
//  HighScore.swift
//  Memory Game
//
//  Created by tamir on 4/24/18.
//  Copyright © 2018 tamir. All rights reserved.
//

import Foundation
import CoreData

class HighScore: NSManagedObject {
    
    // MARK: - Consts
    
    public static let TABLE_NAME = "HighScores"
    private static let SECONDS_IN_MINUTE = 60
    private static let SECONDS_IN_HOUR = SECONDS_IN_MINUTE * 60
    
    // MARK: - Members
    
    @NSManaged var name: String!
    @NSManaged var secondsPlayed: NSNumber!
    @NSManaged var difficulty: NSNumber!
    
    // MARK: - Properties
    
    var Minutes: Int {
        return (secondsPlayed.intValue - Hours * HighScore.SECONDS_IN_HOUR) / HighScore.SECONDS_IN_MINUTE
    }
    
    var Seconds: Int {
        return secondsPlayed.intValue - Hours * HighScore.SECONDS_IN_HOUR - Minutes * HighScore.SECONDS_IN_MINUTE
    }
    
    var Hours: Int {
        return secondsPlayed.intValue / HighScore.SECONDS_IN_HOUR
    }
    
    // MARK: - Ctor
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    // MARK: - Methods
    
    static func durationToAbsoluteSeconds(duration: GameDuration) -> Int{
        return duration.Hours * HighScore.SECONDS_IN_HOUR + duration.Minutes * HighScore.SECONDS_IN_MINUTE + duration.Seconds
    }
    
    @discardableResult
    func save() -> Bool {
        var isSaved = false
        do {
            try self.managedObjectContext?.save()
            isSaved = true
        } catch {}
        
        return isSaved
    }
    
    func remove() {
        self.managedObjectContext?.delete(self)
    }
    
    // We have this method thanks to the NSObject inheritance
    override var description: String {
        return String(format: "%02d:%02d:%02d", Hours, Minutes, Seconds)
    }
}
