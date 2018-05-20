//
//  Card.swift
//  Memory Game
//
//  Created by Tamir on 11/05/2018.
//  Copyright © 2018 tamir. All rights reserved.
//

import Foundation
import CoreData

class CardImage: NSManagedObject {
    
    // MARK: - Enums
    
    enum ImageType: Int {
        case Default
        // The predefined image
        case File
        
        static let allValues = [Default, File]
        
        init?(id : Int) {
            switch id {
            case 0:
                self = .Default
            case 1:
                self = .File
            default:
                return nil
            }
        }
    }
    
    // MARK: - Consts
    
    public static let TABLE_NAME = "CardImages"
    
    // MARK: - Members
    
    @NSManaged var card_type: NSNumber!
    @NSManaged var source_type: NSNumber!
    
    // MARK: - Properties
    
    var CardType: Int {
        return card_type.intValue
    }
    
    var SourceType: ImageType? {
        return ImageType(id: source_type.intValue)
    }
    
    // MARK: - Ctor
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    // MARK: - Methods
    
    @discardableResult
    func save() -> Bool {
        var isSaved = false
        do {
            try self.managedObjectContext?.save()
            isSaved = true
        } catch {}
        
        return isSaved
    }
}
