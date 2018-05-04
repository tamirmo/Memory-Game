//
//  CardChangedDelegate.swift
//  Memory Game
//
//  Created by tamir on 3/31/18.
//  Copyright © 2018 tamir. All rights reserved.
//

import Foundation

protocol GameManagerDelegate: class{
    func cardChanged(row: Int, col: Int) -> Void
    func gameWon() -> Void
    func durationUpdated(time: GameDuration) -> Void
}
