//
//  Comment.swift
//  Continuum
//
//  Created by William Moody on 6/4/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import Foundation

class Comment {
    var comment: String
    var timeStamp: Date
    weak var post: Post?
    
    init(comment: String, timeStamp: Date = Date.init(), post: Post) {
        self.comment = comment
        self.timeStamp = timeStamp
        self.post = post
    }
}
