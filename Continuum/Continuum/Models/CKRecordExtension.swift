//
//  CKRecordExtension.swift
//  Continuum
//
//  Created by William Moody on 6/6/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import UIKit
import CloudKit

extension CKRecord {
    convenience init(post: Post) {
        self.init(recordType: PostConstants.typeKey, recordID: post.recordID)
        //capt time asset commentCount
        self.setValue(post.caption, forKey: PostConstants.captionKey)
        self.setValue(post.timeStamp, forKey: PostConstants.timeStampKey)
        self.setValue(post.imageAsset, forKey: PostConstants.photoKey)
        self.setValue(post.commentCount, forKey: PostConstants.commentCountKey)
    }
    
    convenience init(comment: Comment) {
        self.init(recordType: commentConstants.recordType, recordID: comment.recordID)
        //postref text time
        self.setValue(comment.postReference, forKey: commentConstants.postReferenceKey)
        self.setValue(comment.comment, forKey: commentConstants.textKey)
        self.setValue(comment.timeStamp, forKey: commentConstants.timeStampKey)
    }
}
