//
//  ScoresManager.swift
//  Memory Game
//
//  Created by tamir on 4/24/18.
//  Copyright © 2018 tamir. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ScoresManager{
    
    // MARK: - Consts
    
    public static let MAX_SCORES_FOR_DIFFICULTY = 10
    
    // MARK: - Members
    
    var context : NSManagedObjectContext?
    var scores : [HighScore]? = nil
    
    // MARK: - Ctor
    
    init() {
        // Using the delegate of the app is prohibited outside the ui thread:
        DispatchQueue.main.async {[weak self] in
            self?.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }
    }
    
    // MARK: - Methods
    
    /**
     This method adds the given score only if it is a new high score
     (higher than all others on the table or the table is not yet full).
     - Parameter difficulty: The difficulty of the score to add.
     - Parameter name: The name of the player this score belongs to.
     - Parameter time: The time of the score to add.
     - returns: The score record thar was created if added, nil if not added.
     */
    func addScore(difficulty: GameManager.Difficulty, name:String, time: GameDuration) -> HighScore?{
        var highScore: HighScore? = nil
        
        // Calculating the absolute time of the given score
        let scoreAbsoluteSeconds = HighScore.durationToAbsoluteSeconds(duration: time)
        
        // Getting the number of scores in the difficulty
        let scoresCount = getScoresCount(difficulty: difficulty.rawValue)
        
        let lowestScore = pullLowestScore(difficulty: difficulty)
        
        // There is more space for the new score
        // or the score is better than the slowest exist in the difficulty
        if scoresCount! < ScoresManager.MAX_SCORES_FOR_DIFFICULTY ||
            (lowestScore != nil &&
                lowestScore!.secondsPlayed.intValue > scoreAbsoluteSeconds){
            
            // Adding the new score :
            
            let entity = NSEntityDescription.entity(forEntityName: HighScore.TABLE_NAME, in: context!)
            highScore = HighScore(entity: entity!, insertInto: context)
            highScore!.setValue(name, forKey: "name")
            highScore!.setValue(scoreAbsoluteSeconds, forKey: "secondsPlayed")
            highScore!.setValue(difficulty.rawValue, forKey: "difficulty")
            
            // Checking if we need to delete a score
            // (max score has reached)
            if scoresCount! >= ScoresManager.MAX_SCORES_FOR_DIFFICULTY {
                // Deleting the lowest score found in this difficulty
                lowestScore?.remove()
            }
            
            highScore?.save()
        }
        
        return highScore
    }
    
    /**
     This method pulls all the scores in the given difficulty.
     - Parameter difficulty: The difficulty to get it's lowest score.
     - returns: The record with the lowest score in this difficulty.
     */
    func pullLowestScore(difficulty: GameManager.Difficulty) -> HighScore?{
        var lowestScore: HighScore? = nil
        let request = getScoresDifficultyFetchReq(difficulty: difficulty.rawValue)
        
        // Sorting ascending to cause the top to be the largest seconds (slowest)
        request.sortDescriptors = [NSSortDescriptor.init(key: "secondsPlayed", ascending: false)]
        // Taking only the top score
        request.fetchLimit = 1
        
        do {
            // Executing the request and taking the first (lowest)
            let result = try context?.fetch(request)
            lowestScore = (result as? [HighScore])?.first
        } catch {
            print("@@@@@@@@@@@@ Failed")
        }
        
        return lowestScore
    }
    
    /**
     This method pulls all the scores in the given difficulty.
     - Parameter difficulty: The difficulty to get it's scores.
     - returns: The scores in the given difficulty.
     */
    func pullAllScores(difficulty: Int) -> [HighScore]?{
        let request = getScoresDifficultyFetchReq(difficulty: difficulty)
        // The longest time the score is, the lowest it's rank
        request.sortDescriptors = [NSSortDescriptor.init(key: "secondsPlayed", ascending: true)]
        
        do {
            let result = try context?.fetch(request)
            scores = result as? [HighScore]
        } catch {
            print("@@@@@@@@@@@@ Failed")
        }
        
        return scores
    }
    
    /**
     This method returns the number of scores for the given difficulty.
     - Parameter difficulty: The difficulty to get it's number of scores.
     - returns: The number of scores for the given difficulty.
     */
    private func getScoresCount(difficulty: Int) -> Int?{
        var count: Int? = nil
        let request = getScoresDifficultyFetchReq(difficulty: difficulty)
        
        do {
            count = try context?.count(for: request)
        } catch {
            print("@@@@@@@@@@@@ Failed count")
        }
        
        return count
    }
    
    /**
     This method creates a fetch request for the scores core data base with the given difficulty.
     - Parameter difficulty: The difficulty to create a fetch for.
     - returns: A fetch request for the scores core data base with the given difficulty
     */
    private func getScoresDifficultyFetchReq(difficulty: Int) -> NSFetchRequest<NSFetchRequestResult>{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: HighScore.TABLE_NAME)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "difficulty == \(difficulty)")
        return request
    }
}
