//
//  CardViewCell.swift
//  Memory Game
//
//  Created by tamir on 3/31/18.
//  Copyright © 2018 tamir. All rights reserved.
//

import UIKit

class CardViewCell: UICollectionViewCell{
    // MARK: Properties
    
    // The prefix of all cards images (adding a number will lead to an existing image
    private static let CARD_IMAGES_PREFIX: String = "card_"
    
    @IBOutlet weak var cardImage: UIImageView!
    private var indexPath: IndexPath?
    
    // MARK: Methods
    
    func setIndexPath(indexPath: IndexPath) -> Void {
        self.indexPath = indexPath
    }
    
    func updateImage() -> Void {
        // Getting the cell to update
        let cell = GameManager.getInstance().getCell(cellRow: indexPath!.section, cellColumn: indexPath!.row)
        
        // Checking if the player has not yet coupled it
        if !(cell!.getCoupled()) {
            
            isHidden = false
            // Checking if we need to display the revealed image or the actual card
            if cell!.getRevealed() {
                print(CardViewCell.CARD_IMAGES_PREFIX + String(describing: cell!.getType()))
                // (The images names are 1 based)
                cardImage.image = UIImage(named:CardViewCell.CARD_IMAGES_PREFIX + String(describing: cell!.getType()))
                // Animating the card's change
                UIView.transition(with: cardImage, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            }
            else{
                cardImage.image = #imageLiteral(resourceName: "unrevealed_card")
                // Animating the card's change
                UIView.transition(with: cardImage, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
            }
        }
        // The card is not relevant, hiding it
        else{
            isHidden = true
        }
        
        cardImage.contentMode = .scaleAspectFit
    }
}
