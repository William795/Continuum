//
//  Post.swift
//  Continuum
//
//  Created by William Moody on 6/4/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import UIKit

class Post {
    var photoData: Data?
    let timeStamp: Date
    let caption: String
    var comment: [Comment]
    
    var photo: UIImage? {
        get {
            guard let photoData = photoData else {return nil}
            return UIImage(data: photoData)
        }
        set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    init(photoData: Data?, timeStamp: Date, caption: String, comment: [Comment], photo: UIImage) {
        self.photoData = photoData
        self.timeStamp = timeStamp
        self.caption = caption
        self.comment = comment
        self.photo = photo
    }
}
