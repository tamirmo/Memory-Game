//
//  BoardCell.swift
//  Memory Game
//
//  Created by tamir on 3/30/18.
//  Copyright © 2018 tamir. All rights reserved.
//

import Foundation

class BoardCell{
    // MARK: - Members
    
    private var isRevealed: Bool
    private var type: Int
    // Insicating if this cell was already coupled
    private var isCoupled: Bool
    private let row: Int
    private let col: Int
    
    // MARK: - Ctor
    
    init(type: Int, row: Int, col: Int) {
        isRevealed = false
        self.type = type
        self.isCoupled = false
        self.row = row
        self.col = col
    }
    
    // MARK: - Getters & Setters
    
    func setRevealed(isRevealed: Bool) -> Void {
        self.isRevealed = isRevealed
    }
    
    func getRevealed() -> Bool {
        return self.isRevealed
    }
    
    func getType() -> Int {
        return type
    }
    
    func setCoupled(isCoupled: Bool) -> Void {
        self.isCoupled = isCoupled
    }
    
    func getCoupled() -> Bool {
        return self.isCoupled
    }
    
    func getCol() -> Int {
        return col
    }
    
    func getRow() -> Int {
        return row
    }
}
