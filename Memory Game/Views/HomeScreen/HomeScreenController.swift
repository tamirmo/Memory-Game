//
//  ViewController.swift
//  Memory Game
//
//  Created by tamir on 3/20/18.
//  Copyright © 2018 tamir. All rights reserved.
//

import UIKit
import CoreData


class HomeScreenController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    // MARK: Members
    
    @IBOutlet weak var difficultyPicker: UIPickerView!
    @IBOutlet weak var goImageView: UIImageView!
    @IBOutlet weak var playerNameText: UITextField!
    @IBOutlet weak var highScoresImageView: UIImageView!
    @IBOutlet weak var editImagesView: UIImageView!
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GameManager.Difficulty.allValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: GameManager.Difficulty.allValues[row].string, attributes: [NSAttributedStringKey.foregroundColor:UIColor.purple])
    }
    
    @objc func goTapped(tapGestureRecognizer: UITapGestureRecognizer){
        if playerNameText.text == "" {
            AlertDisplayer.showAlert(title: "Name error", msg: "Enter a valid name", controller: self)
        }else{
            // Getting the chosen difficulty and initializing the board
            let selectedDifficultyIndex = difficultyPicker.selectedRow(inComponent: 0)
            let difficultyChosen = GameManager.Difficulty.allValues[selectedDifficultyIndex]
            
            GameManager.getInstance().initializeGame(difficulty: difficultyChosen, playerName: playerNameText.text!)
            
            // Moving to the game board:
            let gameBoardController = self.storyboard?.instantiateViewController(withIdentifier: "GameBoardController") as! GameBoardController
            self.navigationController!.pushViewController(gameBoardController, animated: true)
        }
    }
    
    @objc func highScoresTapped(tapGestureRecognizer: UITapGestureRecognizer){
        // Getting the chosen difficulty
        let selectedDifficultyIndex = difficultyPicker.selectedRow(inComponent: 0)
        let difficultyChosen = GameManager.Difficulty.allValues[selectedDifficultyIndex]
        
        // Moving to the scores view:
        let scoresController = self.storyboard?.instantiateViewController(withIdentifier: "ScoresController") as! ScoresController
        
        scoresController.setScoresParams(difficulty: difficultyChosen, userScore: nil)
        
        // Presenting and not pushing cause we do not want to go back here
        self.navigationController!.pushViewController(scoresController, animated: true)
    }
    
    @objc func editImagesTapped(tapGestureRecognizer: UITapGestureRecognizer){
        // Moving to the scores view:
        let scoresController = self.storyboard?.instantiateViewController(withIdentifier: "EditImagesController") as! EditImagesController
        
        // Presenting and not pushing cause we do not want to go back here
        self.navigationController!.pushViewController(scoresController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context : NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Initializing the DB managers to prepare for the game (initializing only if not already initialized)
        GameManager.getInstance().initDBManagers(context: (context))
        
        difficultyPicker.dataSource = self
        difficultyPicker.delegate = self
        
        // Setting click event for the go image:
        let goGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goTapped(tapGestureRecognizer:)))
        goImageView.addGestureRecognizer(goGestureRecognizer)
        goImageView.isUserInteractionEnabled = true
        
        // Setting click event for the edit images:
        let editImagesGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editImagesTapped(tapGestureRecognizer:)))
        editImagesView.addGestureRecognizer(editImagesGestureRecognizer)
        editImagesView.isUserInteractionEnabled = true
        
        // Setting click event for the scores image:
        let scoresTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(highScoresTapped(tapGestureRecognizer:)))
        highScoresImageView.addGestureRecognizer(scoresTapGestureRecognizer)
        highScoresImageView.isUserInteractionEnabled = true
        
        // Setting background:
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        
        // Setting navigation bar transparent:
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
}

