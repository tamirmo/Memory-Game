//
//  CardImageCreator.swift
//  Memory Game
//
//  Created by Tamir on 12/05/2018.
//  Copyright © 2018 tamir. All rights reserved.
//

import Foundation
import UIKit

class CardImageCreator {
    // The prefix of all cards images (adding a number will lead to an existing image
    private static let CARD_IMAGES_PREFIX: String = "card_"
    
    static func CreateImage(cardImage: CardImage, type: Int) -> UIImage?{
        var image: UIImage? = nil
        
        if cardImage.SourceType == CardImage.ImageType.Default {
            image = UIImage(named:CardImageCreator.CARD_IMAGES_PREFIX + String(describing: type))
        }
        else if cardImage.SourceType == CardImage.ImageType.File {
            let nsDucumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
            let paths = NSSearchPathForDirectoriesInDomains(nsDucumentDirectory, nsUserDomainMask, true)
            
            if let dirPath = paths.first
            {
                let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(String(type) + ".JPG")
                
                image = UIImage(contentsOfFile: imageUrl.path)
            }
        }
        
        return image
    }
}
