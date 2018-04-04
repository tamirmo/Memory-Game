//
//  WinController.swift
//  Memory Game
//
//  Created by tamir on 4/1/18.
//  Copyright © 2018 tamir. All rights reserved.
//

import UIKit

class WinController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Settign background:
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        
        // Setting the navigation controller transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    
}
