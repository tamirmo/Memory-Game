//
//  CardsManager.swift
//  Memory Game
//
//  Created by Tamir on 11/05/2018.
//  Copyright © 2018 tamir. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CardsImagesManager {
    // MARK: - Consts
    
    // MARK: - Members
    
    private weak var context : NSManagedObjectContext?
    private var cardsImages : [CardImage]? = nil
    private var cardsQueue : DispatchQueue
    
    // MARK: - Ctor
    
    init(context : NSManagedObjectContext) {
        // Using the delegate of the app is prohibited outside the ui thread:
        self.context = context
        
        self.cardsQueue = DispatchQueue(label: "cardsManager", attributes: DispatchQueue.Attributes.concurrent)
        
        self.cardsQueue.async {[weak self] in
            // Getting all cards from the DB
            self?.cardsImages = self?.pullAllCards()
            
            // If the DB was not yet initialized
            if self?.cardsImages == nil || self?.cardsImages?.count == 0 {
                // Creating it
                self?.cardsImages = self?.addCards()
            }
        }
    }
    
    // MARK: - Methods
    
    /**
     This method adds default cards (with type default). It is called when the Cards table is first created.
     - returns: The score record thar was created if added, nil if not added.
     */
    func addCards() -> [CardImage] {
        
        var cards = [CardImage]()
        
        // Adding the all cards :
        
        for index  in 0...GameManager.getInstance().getMaxTypes() - 1{
            let entity = NSEntityDescription.entity(forEntityName: CardImage.TABLE_NAME, in: context!)
            let card = CardImage(entity: entity!, insertInto: context)
            card.setValue(index, forKey: "card_type")
            card.setValue(CardImage.ImageType.Default.rawValue, forKey: "source_type")
            
            cards.append(card)
            card.save()
        }
        
        return cards
    }
    
    func getCardImage(type: Int) -> CardImage?{
        return cardsImages?[type]
    }
    
    func updateCard(type: Int, imageType: CardImage.ImageType, cardsImagesDelegate: CardsImagesDelegate){
        self.cardsQueue.async {[weak self] in
            self?.cardsImages?[type].setValue(imageType.rawValue, forKey: "source_type")
            
            // Saving for next runs
            self?.cardsImages?[type].save()
            cardsImagesDelegate.cardImageUpdatFinished()
        }
    }
    
    /**
     This method pulls all the cards.
     - returns: All cards.
     */
    func pullAllCards() -> [CardImage]?{
        // Creating the request
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CardImage.TABLE_NAME)
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [NSSortDescriptor.init(key: "card_type", ascending: true)]
        
        do {
            let result = try context?.fetch(request)
            cardsImages = result as? [CardImage]
        } catch {
            print("@@@@@@@@@@@@ Failed")
        }
        
        return cardsImages
    }
}
