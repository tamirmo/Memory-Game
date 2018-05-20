//
//  ChooseImageSourceController.swift
//  Memory Game
//
//  Created by Tamir on 12/05/2018.
//  Copyright © 2018 tamir. All rights reserved.
//

import UIKit

import Foundation
import MobileCoreServices


class ChooseImageSourceController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CardsImagesDelegate{
    
    // MARK: - Members
    @IBOutlet weak var goImage: UIImageView!
    @IBOutlet weak var chooseSourceTextView: UITextView!
    @IBOutlet weak var sourcePickerView: UIPickerView!
    @IBOutlet weak var imageUrlTextInput: UITextField!
    @IBOutlet weak var loadingImageView: UIImageView!
    // Containing the loading image and label
    @IBOutlet weak var loadingView: UIView!
    
    private var typeToEdit: Int? = nil
    private let imagePickerController = UIImagePickerController()
    private var loadingAnimation: CABasicAnimation?
    
    // MARK: Static
    private static let SOURCE_TYPES: [String] = ["Library", "Camera", "Moments", "Default", "Link"]
    
    // MARK: - Methods
    
    public func setTypeEdit(typeToEdit: Int){
        self.typeToEdit = typeToEdit
    }
    
    private func showImagePicker(sourceType: Int){
        showLoadingScreen()
        
        // Getting the source cchosen and checking if is is available in the device
        guard let selectedSourceType = UIImagePickerControllerSourceType(rawValue: sourceType), UIImagePickerController.isSourceTypeAvailable(selectedSourceType) else {
            hideLoadingScreen()
            
            // Alerting the user the source is not available:
            let errorString: String = "😱 Selected input type isn't available"
            AlertDisplayer.showAlert(title: "Unavilable type", msg: errorString, controller: self)
            return
        }
        
        // Registering to the picker's events
        imagePickerController.delegate = self
        // Setting the source type the user chose
        imagePickerController.sourceType = selectedSourceType
        
        // Allowing only images to be chosen
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func goTapped(tapGestureRecognizer: UITapGestureRecognizer){
        // Getting the chosen type
        let selectedTypeIndex = sourcePickerView.selectedRow(inComponent: 0)
        
        // One of the Picker options
        if selectedTypeIndex >= 0 && selectedTypeIndex <= 2 {
            showImagePicker(sourceType: selectedTypeIndex)
        }
        // Default option
        else if selectedTypeIndex == 3 {
            // Updating the card in the DB (async)
            GameManager.getInstance().setCardImage(type: self.typeToEdit!, imageType: CardImage.ImageType.Default, cardsImagesDelegate: self as CardsImagesDelegate)
            showLoadingScreen()
        }
        // URL option
        else if selectedTypeIndex == 4 {
            downloadImage(url: URL(string: imageUrlTextInput.text!)!)
            showLoadingScreen()
        }
    }
    
    /**
     This method downloads the given url of an image.
     - Parameter url: The url to download from.
     - Parameter completion: Delegate to go to when download completes.
     */
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        // Starting to download
        URLSession.shared.dataTask(with: url) { data, response, error in
            // When done, calling the completion Delegate
            completion(data, response, error)
            }.resume()
    }
    
    /**
     Starting an async task to download the image in the given URL.
     - Parameter url: The url to download from.
     */
    func downloadImage(url: URL) {
        // Downloading and assigning a delegate
        getDataFromUrl(url: url) { data, response, error in
            var isValidImage: Bool = false
            // Checking if download went well
            if error == nil && data != nil && data!.count > 0 {
                let image: UIImage? = UIImage(data: data!)
                if image != nil {
                    self.saveImage(image: image!)
                    isValidImage = true
                }
            }
            
            // If found an error
            if !isValidImage {
                // Displaying an error and showing the picker and other controls
                let errorString: String = "Error downloading the image!"
                DispatchQueue.main.async { [weak self] in
                    if self != nil {
                        AlertDisplayer.showAlert(title: "Download Failed", msg: errorString, controller: self!)
                        self!.hideLoadingScreen()
                    }
                }
            }
        }
    }
    
    private func showLoadingScreen(){
        // Showing the loading view:
        loadingView.isHidden = false
        
        // Hiding the other views
        goImage.isHidden = true
        chooseSourceTextView.isHidden = true
        sourcePickerView.isHidden = true
        imageUrlTextInput.isHidden = true
        
        // Spinning the loading image:
        loadingAnimation = CABasicAnimation(keyPath: "transform.rotation")
        loadingAnimation?.fromValue = 0.0
        loadingAnimation?.toValue = Double.pi * 2
        loadingAnimation?.duration = 1
        loadingAnimation?.repeatCount = .infinity
        loadingImageView.layer.add(loadingAnimation!, forKey: nil)
    }
    
    private func hideLoadingScreen(){
        // Hiding the loading view:
        loadingView.isHidden = true
        
        // Showing the other views
        goImage.isHidden = false
        chooseSourceTextView.isHidden = false
        sourcePickerView.isHidden = false
        setURLTextViewVisability()
        
        // Stopping the loading image animation:
        loadingImageView.layer.removeAllAnimations()
    }
    
    func saveImage(image: UIImage){
        // Getting the documents directory and creating a URL from it:
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let photoURL          = NSURL(fileURLWithPath: documentDirectory)
        
        // Adding to the path created the type of the card with ".JPG" exstenssion
        let localPath         = photoURL.appendingPathComponent(String(describing: self.typeToEdit!) + ".JPG")
        
        do {
            // Saving the file with no compression (1.0)
            try UIImageJPEGRepresentation(image, 1.0)?.write(to: localPath!)
            // Updating the card in the DB (async)
            GameManager.getInstance().setCardImage(type: self.typeToEdit!, imageType: CardImage.ImageType.File, cardsImagesDelegate: self as CardsImagesDelegate)
        }catch {
            print("error saving file")
        }
    }
    
    private func setURLTextViewVisability(){
        // If the chosen source type is URL
        if sourcePickerView.selectedRow(inComponent: 0) == 4 {
            imageUrlTextInput.isHidden = false
        }else{
            imageUrlTextInput.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting background:
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        
        // Setting the navigation controller transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        // Setting click event for the go image:
        let goGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goTapped(tapGestureRecognizer:)))
        goImage.addGestureRecognizer(goGestureRecognizer)
        goImage.isUserInteractionEnabled = true
        
        loadingView.isHidden = true
    }
    
    // MARK: CardsImagesDelegate
    
    func cardImageUpdatFinished(){
        DispatchQueue.main.async { [weak self] in
            print("file saved")
            self?.navigationController?.popViewController(animated: true)
            self?.loadingImageView.layer.removeAllAnimations()
        }
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ChooseImageSourceController.SOURCE_TYPES.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: ChooseImageSourceController.SOURCE_TYPES[row], attributes: [NSAttributedStringKey.foregroundColor:UIColor.purple])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setURLTextViewVisability()
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        hideLoadingScreen()
        
        // No need for the picker anymore
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Sacing a file takes time
        showLoadingScreen()
        
        // Getting the image chosen
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        saveImage(image: image)
        
        // No need for the picker anymore
        picker.dismiss(animated: true, completion: nil)
    }
}
