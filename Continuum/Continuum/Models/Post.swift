//
//  Post.swift
//  Continuum
//
//  Created by William Moody on 6/4/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import UIKit
import CloudKit

class Post {
    var photoData: Data?
    let timeStamp: Date
    let caption: String
    var comments: [Comment]
    
    var photo: UIImage? {
        get {
            guard let photoData = photoData else {return nil}
            return UIImage(data: photoData)
        }
        set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    init(photo: UIImage, timeStamp: Date = Date(), caption: String, comment: [Comment]) {
        self.timeStamp = timeStamp
        self.caption = caption
        self.comments = comment
        self.photo = photo
    }
}

extension Post: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        if caption.contains(searchTerm) {
            return true
        }else {
            for comment in comments {
                if comment.matches(searchTerm: searchTerm) {
                    return true
                }
            }
        }
        return false
    }
}
