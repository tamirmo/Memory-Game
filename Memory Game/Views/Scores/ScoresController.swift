//
//  WinController.swift
//  Memory Game
//
//  Created by tamir on 4/1/18.
//  Copyright © 2018 tamir. All rights reserved.
//

import UIKit

class ScoresController: UIViewController, UITableViewDataSource, UITableViewDelegate, ScoresDelegate{
    
    // MARK: - Members
    
    @IBOutlet weak var scoresTableView: UITableView!
    @IBOutlet weak var difficultyLabel: UILabel!
    // The score ("hh:mm:ss")
    @IBOutlet weak var userScoreLabel: UILabel!
    // A label with "Your score: " text
    @IBOutlet weak var yourScoreLabel: UILabel!
    
    private var scores : [HighScore]? = nil
    private var difficulty: GameManager.Difficulty?
    private var userScore: GameDuration?
    // The user's score
    private var selectedScore: HighScore?
    
    // Indicating if we need to display the current score now or the user clicked high scores from the home screen
    private var wasGameJustEnded: Bool = false
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Settign background:
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        
        // Setting the navigation controller transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        // Registering to the back button press
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.done, target: self, action: #selector(ScoresController.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        // Showing/hiding the user's score labels according to the user's origin screen
        // (home screen -> wasGameJustEnded = false)
        // (game -> wasGameJustEnded = true)
        yourScoreLabel.isHidden = !wasGameJustEnded
        userScoreLabel.isHidden = !wasGameJustEnded
        
        difficultyLabel.text = difficulty?.string
        userScoreLabel.text = userScore?.description
    }
    
    /**
     This starts adds the given score to the database and pulls the scores of the given difficulty.
     - Parameter userScore: The score just ended (nil if calling from HomeScreen).
     - Parameter difficulty: The difficulty of the scores.
     */
    public func setScoresParams(difficulty: GameManager.Difficulty, userScore: GameDuration?){
        self.userScore = userScore
        self.difficulty = difficulty
        
        // If a the user has just ended a game
        if userScore != nil {
            // Indicating we need to display the user's score labels
            wasGameJustEnded = true
            // Trying to add the current score to the database.
            GameManager.getInstance().addLastScoreToHighScores(scoresDelegate: self as ScoresDelegate)
        }
        // No game just ended
        else{
            // Pulling the results for the difficulty
            GameManager.getInstance().getHighScores(difficulty: (self.difficulty!), scoresDelegate: self as ScoresDelegate)
        }
    }
    
    // MARK: ScoresDelegate
    
    func scoreAdded(score: HighScore?) {
        if  score != nil {
            // Saving and adding the score
            self.selectedScore = score
        }
        
        // Pulling the results for the difficulty after adding
        GameManager.getInstance().getHighScores(difficulty: (self.difficulty!), scoresDelegate: self as ScoresDelegate)
    }
    
    func scoresPulled(scores: [HighScore]?) {
        if  scores != nil {
            // Saving the scores
            self.scores = scores
        }
        
        // Updating UI
        DispatchQueue.main.async { [weak self] in
            if self?.scoresTableView != nil {
                self?.scoresTableView.reloadData()
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scores == nil {
            return 0
        }
        return scores!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get a reference to storyboard cell
        let cell = scoresTableView.dequeueReusableCell(withIdentifier: "ScoreViewCell", for: indexPath as IndexPath) as! ScoreViewCell
        
        // Setting the index and score of the cell
        // (+1 for moving from 0 based to one based)
        cell.setIndex(index: indexPath[1] + 1)
        cell.setScore(score: scores![indexPath[1]])
        // If this score is the last user's score
        if selectedScore?.objectID == scores![indexPath[1]].objectID {
            // Selecting it
            cell.setSelectedScore()
        }
        
        return cell
    }
    
    @objc func back(sender: UIBarButtonItem) {
        // Go back to the previous root controller, the home screen one
        navigationController?.popToRootViewController(animated: true)
    }
}
