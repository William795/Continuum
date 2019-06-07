//
//  Comment.swift
//  Continuum
//
//  Created by William Moody on 6/4/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import Foundation
import CloudKit

struct commentConstants {
    static let recordType = "Comment"
    static let postReferenceKey = "post"
    static let textKey = "comment"
    static let timeStampKey = "timeStamp"
}

class Comment {
    var comment: String
    var timeStamp: Date
    weak var post: Post?
    let recordID: CKRecord.ID
    
    var postReference: CKRecord.Reference? {
        guard let post = post else {return nil}
        return CKRecord.Reference(recordID: post.recordID, action: .deleteSelf)
    }
    
    init(comment: String, timeStamp: Date = Date(), post: Post, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.comment = comment
        self.timeStamp = timeStamp
        self.post = post
        self.recordID = recordID
    }
    convenience init?(ckRecord: CKRecord, post: Post) {
        guard let text = ckRecord[commentConstants.textKey] as? String,
            let timeStamp = ckRecord[commentConstants.timeStampKey] as? Date else {return nil}
        self.init(comment: text, timeStamp: timeStamp, post: post, recordID: ckRecord.recordID)
    }
}

extension Comment: SearchableRecord {
    func matches(searchTerm: String) -> Bool {
        return comment.contains(searchTerm)
    }
}
