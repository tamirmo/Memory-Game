//
//  ScoreAddedDelegate.swift
//  Memory Game
//
//  Created by tamir on 5/19/18.
//  Copyright © 2018 tamir. All rights reserved.
//

import Foundation

protocol ScoresDelegate{
    func scoreAdded(score: HighScore?)
    func scoresPulled(scores: [HighScore]?)
}
