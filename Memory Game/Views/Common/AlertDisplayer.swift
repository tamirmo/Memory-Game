//
//  AlertDisplayer.swift
//  Memory Game
//
//  Created by tamir on 4/1/18.
//  Copyright © 2018 tamir. All rights reserved.
//

import UIKit

class AlertDisplayer{
    static func showAlert(title: String, msg: String, controller: UIViewController){
        // Creating the alert
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        // Assing a button
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        // Displaying the alert
        controller.present(alert, animated: true)
    }
}
