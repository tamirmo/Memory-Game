//
//  CardImageCell.swift
//  Memory Game
//
//  Created by Tamir on 12/05/2018.
//  Copyright © 2018 tamir. All rights reserved.
//

import UIKit

class CardImageViewCell : UICollectionViewCell{
    // MARK: - Members
    
    @IBOutlet weak var image: UIImageView!
    private var indexPath: IndexPath?
    
    // MARK: - Methods
    
    func setIndexPath(indexPath: IndexPath) -> Void {
        self.indexPath = indexPath
    }
    
    func updateImage() -> Void {
        // Calculating the type of the cell
        let cellType: Int = (indexPath!.section * EditImagesController.IMAGES_IN_ROW) + indexPath!.row
        // Getting the cell to display
        let cellImage = GameManager.getInstance().getCardImage(type: cellType)
        
        image.image = CardImageCreator.CreateImage(cardImage: cellImage!, type: cellType)
        
        image.contentMode = .scaleAspectFit
    }
}
