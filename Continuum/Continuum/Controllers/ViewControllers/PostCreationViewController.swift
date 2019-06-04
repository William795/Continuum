//
//  PostCreationViewController.swift
//  Continuum
//
//  Created by William Moody on 6/4/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import UIKit

class PostCreationViewController: UIViewController {

    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var postCaptionLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectImageView.isHidden = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        selectImageView.isHidden = true
    }
    
    @IBAction func addPostButtonTapped(_ sender: Any) {
        guard let image = selectImageView.image, let text = postCaptionLabel.text else {return}
        if text.isEmpty || image == UIImage(named: "og"){
            return
        }
        PostController.shared.createPostWith(image: image, caption: text) { (post) in
            
            self.selectImageView.isHidden = true
            self.postCaptionLabel.text = ""
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
        selectImageView.isHidden = false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
