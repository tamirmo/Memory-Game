//
//  GameDuration.swift
//  Memory Game
//
//  Created by Tamir on 27/04/2018.
//  Copyright © 2018 tamir. All rights reserved.
//

import Foundation

class GameDuration{
    
    // MARK: - Members
    
    private var hours: Int
    private var minutes: Int
    private var seconds: Int
    
    // MARK: - Properties
    
    var Minutes: Int {
        get{
            return minutes
        }
        set{
            minutes = newValue
        }
    }
    
    var Seconds: Int {
        get{
            return seconds
        }
        set{
            seconds = newValue
        }
    }
    
    var Hours: Int {
        get{
            return hours
        }
        set{
            hours = newValue
        }
    }
    
    var description: String {
        return String(format: "%02d:%02d:%02d", Hours, Minutes, Seconds)
    }
    
    // MARK: - Ctor
    
    init(hours: Int, minutes: Int, seconds: Int){
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }
}
