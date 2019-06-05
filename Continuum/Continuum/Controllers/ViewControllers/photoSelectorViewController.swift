//
//  photoSelectorViewController.swift
//  Continuum
//
//  Created by William Moody on 6/5/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import UIKit

protocol photoSelectorViewControllerDelegate: class {
    func photoSelectorViewControllerSelectedImage(image: UIImage)
}

class photoSelectorViewController: UIViewController {

    @IBOutlet weak var selectedPhotoImageView: UIImageView!
    @IBOutlet weak var selectPhotoButton: UIButton!
    
    weak var delegate: photoSelectorViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        selectPhotoButton.setTitle("Select Photo", for: .normal)
        selectedPhotoImageView.image = nil
    }
    
    @IBAction func photoSelectorButtonTapped(_ sender: Any) {
        presentImagePickerActionSheet()
    }
}

extension photoSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectPhotoButton.setTitle("", for: .normal)
            selectedPhotoImageView.image = photo
            delegate?.photoSelectorViewControllerSelectedImage(image: photo)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func presentImagePickerActionSheet() {
        //making variable = a view controller that manages all user meadia library functions (choose/take pics,recordings ect...
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        //making alert controller
        let actionSheet = UIAlertController(title: "Select a Photo", message: nil, preferredStyle: .actionSheet)
        //checks to see if we can access their media library
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //makes button for selecting a photo
            actionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (_) in
                //brings up their media library
                imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        //checks for camera access
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //makes button for selecing camera
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                //brings up camera stuff
                imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        //makes button to cancel
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)

    }
}
