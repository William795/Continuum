//
//  PostCreationViewController.swift
//  Continuum
//
//  Created by William Moody on 6/4/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import UIKit

class PostCreationViewController: UIViewController {

    @IBOutlet weak var postCaptionLabel: UITextField!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromPostCreationToPhotoSelector" {
            let photoSelecter = segue.destination as? photoSelectorViewController
            photoSelecter?.delegate = self
        }
    }
    
    @IBAction func addPostButtonTapped(_ sender: Any) {
        guard let image = selectedImage,
            let text = postCaptionLabel.text
            else {return}
        if text.isEmpty {
            return
        }
        PostController.shared.createPostWith(image: image, caption: text) { (post) in }
            self.tabBarController?.selectedIndex = 0
    }
    @IBAction func cancleButtonTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
}

extension PostCreationViewController: photoSelectorViewControllerDelegate {
    func photoSelectorViewControllerSelectedImage(image: UIImage) {
        selectedImage = image
    }
}
