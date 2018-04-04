//
//  GetIndexPathDelegate.swift
//  Memory Game
//
//  Created by tamir on 3/31/18.
//  Copyright © 2018 tamir. All rights reserved.
//

import UIKit

protocol GetIndexPathDelegate: class {
    // Getting the index path of the cell
    func indexPathForCell(cell:UICollectionViewCell) -> IndexPath?
}
