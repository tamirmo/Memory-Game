//
//  ViewController.swift
//  Memory Game
//
//  Created by tamir on 3/20/18.
//  Copyright © 2018 tamir. All rights reserved.
//

import UIKit


class HomeScreenController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    // MARK: Properties
    @IBOutlet weak var difficultyPicker: UIPickerView!
    @IBOutlet weak var goImageView: UIImageView!
    @IBOutlet weak var playerNameText: UITextField!
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GameManager.Difficulty.allValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: GameManager.Difficulty.allValues[row].rawValue, attributes: [NSAttributedStringKey.foregroundColor:UIColor.purple])
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        difficultyPicker.dataSource = self
        difficultyPicker.delegate = self
        
        // Setting click event for the go image:
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goTapped(tapGestureRecognizer:)))
        goImageView.addGestureRecognizer(tapGestureRecognizer)
        goImageView.isUserInteractionEnabled = true
        
        // Settign background:
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        
        // Setting navigation bar transparent:
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
}

