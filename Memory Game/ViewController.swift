//
//  ViewController.swift
//  Memory Game
//
//  Created by tamir on 3/20/18.
//  Copyright © 2018 tamir. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate  {
    // MARK: Properties
    @IBOutlet weak var difficultyPicker: UIPickerView!
    
    let difficulties = ["Beginners", "Intermediate", "Expert"]
    
    // MARK: UIPickerViewDataSource
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return difficulties[row]
    }
    
    // MARK: UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return difficulties.count
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        difficultyPicker.dataSource = self
        difficultyPicker.delegate = self
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

