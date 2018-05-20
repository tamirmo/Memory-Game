//
//  EditImagesController.swift
//  Memory Game
//
//  Created by Tamir on 11/05/2018.
//  Copyright © 2018 tamir. All rights reserved.
//

import Foundation
import UIKit

class EditImagesController : UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    // MARK: - Members
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    private static var CELLS_MARGIN:CGFloat = 5
    public static var IMAGES_IN_ROW:Int = 4
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting background:
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        
        // Setting the navigation controller transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reloading data for changes caused by the edit image controller
        imagesCollectionView.reloadData()
    }
    
    /**
     This method calculates the number of rows (sections) needed to display all types with the number of types in each row.
     - returns: The number of rows.
     */
    private func calculateNumOfSections() -> Int{
        var numOfSections: Int = GameManager.getInstance().getMaxTypes() / EditImagesController.IMAGES_IN_ROW
        
        // Checking if we need another row for the left images
        if GameManager.getInstance().getMaxTypes() % EditImagesController.IMAGES_IN_ROW != 0 {
            numOfSections = numOfSections + 1
        }
        
        return numOfSections
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Getting the number of rows and columns
        let columnsCount = EditImagesController.IMAGES_IN_ROW
        let rowsCount = calculateNumOfSections()
        
        // Calculating the size avialable for the cells (substructing the space)
        let collectionViewCellsBoundWidth = (collectionView.bounds.size.width - CGFloat(columnsCount) * EditImagesController.CELLS_MARGIN)
        let collectionViewCellsBoundHeight = (collectionView.bounds.size.height - CGFloat(rowsCount) * EditImagesController.CELLS_MARGIN)
        
        let cellWidth = collectionViewCellsBoundWidth / CGFloat(columnsCount)
        let cellHeight = collectionViewCellsBoundHeight / CGFloat(rowsCount)
        return CGSize(width: Int(cellWidth), height: Int(cellHeight))
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get a reference to storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardImageViewCell", for: indexPath as IndexPath) as! CardImageViewCell
        
        // Setting the index of the cell and updating it's image
        cell.setIndexPath(indexPath: indexPath)
        cell.updateImage()
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Moving to the scores view:
        let chooseImageSourceController = self.storyboard?.instantiateViewController(withIdentifier: "ChooseImageSourceController") as! ChooseImageSourceController
        
        // Setting the type to edit (the item clicked)
        chooseImageSourceController.setTypeEdit(typeToEdit: (indexPath.section * EditImagesController.IMAGES_IN_ROW) + indexPath.row)
        
        // Presenting and not pushing cause we do not want to go back here
        self.navigationController!.pushViewController(chooseImageSourceController, animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return calculateNumOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numOfColumns: Int = EditImagesController.IMAGES_IN_ROW
        
        // If this is the last row
        if section == GameManager.getInstance().getMaxTypes() / EditImagesController.IMAGES_IN_ROW {
            // If there are leftovers
            if GameManager.getInstance().getMaxTypes() % EditImagesController.IMAGES_IN_ROW != 0 {
                // Handling the lefovers
                numOfColumns = GameManager.getInstance().getMaxTypes() % EditImagesController.IMAGES_IN_ROW
            }
        }
        
        return numOfColumns
    }
}

