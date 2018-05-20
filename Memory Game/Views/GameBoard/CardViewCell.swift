//
//  CardViewCell.swift
//  Memory Game
//
//  Created by tamir on 3/31/18.
//  Copyright © 2018 tamir. All rights reserved.
//

import UIKit

class CardViewCell: UICollectionViewCell{
    // MARK: Members
    
    @IBOutlet weak var cardImage: UIImageView!
    private var indexPath: IndexPath?
    
    // MARK: Methods
    
    func setIndexPath(indexPath: IndexPath) -> Void {
        self.indexPath = indexPath
    }
    
    func updateImage() -> Void {
        // Getting the cell to update
        let cell = GameManager.getInstance().getCell(cellRow: indexPath!.section, cellColumn: indexPath!.row)
        let cellImage = GameManager.getInstance().getCardImage(type: cell!.getType())
        
        // Checking if the player has not yet coupled it
        if !(cell!.getCoupled()) {
            
            isHidden = false
            // Checking if we need to display the revealed image or the actual card
            if cell!.getRevealed() {
                cardImage.image = CardImageCreator.CreateImage(cardImage: cellImage!, type: cell!.getType())
            }
            else{
                cardImage.image = #imageLiteral(resourceName: "unrevealed_card")
            }
            
            // Animating the card's change
            UIView.transition(with: cardImage, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
        // The card is not relevant, hiding it
        else{
            isHidden = true
        }
        
        cardImage.contentMode = .scaleAspectFit
    }
}
