//
//  GameBoardController.swift
//  Memory Game
//
//  Created by tamir on 3/30/18.
//  Copyright © 2018 tamir. All rights reserved.
//

import UIKit

class GameBoardController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GameManagerDelegate{
    
    // MARK: Members
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var boardCollectionView: UICollectionView!
    private static var CELLS_MARGIN:CGFloat = 5
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting background:
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        
        // Registering to the manager's delegate
        GameManager.getInstance().delegate = self
        
        // Setting the navigation controller transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        // Setting the current time and player name
        durationUpdated(time: GameManager.getInstance().gameDuration)
        nameLabel.text = GameManager.getInstance().playerName
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        GameManager.getInstance().stopTimeTimer()
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Getting the number of rows and columns
        let columnsCount = GameManager.getInstance().getBoardDimention().cols
        let rowsCount = GameManager.getInstance().getBoardDimention().rows
        
        // Calculating the size avialable for the cells (substructing the space)
        let collectionViewCellsBoundWidth = (collectionView.bounds.size.width - CGFloat(columnsCount) * GameBoardController.CELLS_MARGIN)
        let collectionViewCellsBoundHeight = (collectionView.bounds.size.height - CGFloat(rowsCount) * GameBoardController.CELLS_MARGIN)
        
        let cellWidth = collectionViewCellsBoundWidth / CGFloat(columnsCount)
        let cellHeight = collectionViewCellsBoundHeight / CGFloat(rowsCount)
        return CGSize(width: Int(cellWidth), height: Int(cellHeight))
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardViewCell", for: indexPath as IndexPath) as! CardViewCell
        
        // Setting the index of the cell and updating it's image
        cell.setIndexPath(indexPath: indexPath)
        cell.updateImage()
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Trying to reveal the chosen card
        let result = GameManager.getInstance().revealCell(cellRow: indexPath.section, cellColumn: indexPath.row)
        
        // Checking if reveal was made:
        switch result {
        case GameManager.TurnResult.InvalidCell:
            AlertDisplayer.showAlert(title: "Error", msg: "Internal error, please choose again.", controller: self)
        case GameManager.TurnResult.MaxCardsRevealed:
            break
        case GameManager.TurnResult.AlreadyRevealedCell:
            break
        case GameManager.TurnResult.Revealed:
            // Refreshing the clicked view
            (collectionView.cellForItem(at: indexPath) as? CardViewCell)!.updateImage()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return GameManager.getInstance().getBoardDimention().rows
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GameManager.getInstance().getBoardDimention().cols
    }
    
    // MARK: GameManagerDelegate
    
    func cardChanged(row: Int, col: Int) {
        DispatchQueue.main.async {[weak self] in
            // Refreshing the changed card
            (self?.boardCollectionView.cellForItem(at: IndexPath(indexes: [row, col])) as? CardViewCell)?.updateImage()
        }
    }
    
    func gameWon() {
        DispatchQueue.main.async { [weak self] in
            // Moving to the scores controller:
            let scoresController = self?.storyboard?.instantiateViewController(withIdentifier: "ScoresController") as! ScoresController
            
            scoresController.setScoresParams(difficulty: GameManager.getInstance().gameDifficulty, userScore: GameManager.getInstance().gameDuration)
            
            // Presenting and not pushing cause we do not want to go back here
            //self.present(winController, animated: true, completion: nil)
            self?.navigationController!.pushViewController(scoresController, animated: true)
        }
    }
    
    func durationUpdated(time: GameDuration) {
        DispatchQueue.main.async { [weak self] in
            self?.timeLabel.text = time.description
        }
    }
}
