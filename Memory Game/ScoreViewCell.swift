//
//  ScoreViewCell.swift
//  Memory Game
//
//  Created by tamir on 4/25/18.
//  Copyright © 2018 tamir. All rights reserved.
//

import Foundation

import UIKit

class ScoreViewCell: UITableViewCell{
    // MARK: Members
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    private var index: Int?
    private var score: HighScore?
    
    // MARK: Methods
    
    func setIndex(index: Int) -> Void {
        self.index = index
        rankLabel.text = String(index)
    }
    
    func setScore(score: HighScore){
        self.score = score
        
        timeLabel.text = score.description
        nameLabel.text = score.name
    }
    
    func setSelectedScore(){
        rankLabel.textColor = UIColor.green
        nameLabel.textColor = UIColor.green
        timeLabel.textColor = UIColor.green
    }
}
