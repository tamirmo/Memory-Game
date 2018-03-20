//
//  GameManager.swift
//  Memory Game
//
//  Created by tamir on 3/20/18.
//  Copyright © 2018 tamir. All rights reserved.
//

import Foundation

class GameManager{
    
    // MARK: - Properties
    
    private static var shared: GameManager? = nil
    
    // MARK: - Accessors
    
    class func getInstance() -> GameManager {
        if shared == nil {
            shared = GameManager()
        }
        return shared!
    }
    
    
}
