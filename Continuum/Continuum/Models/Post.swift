//
//  Post.swift
//  Continuum
//
//  Created by William Moody on 6/4/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import UIKit
import CloudKit

struct PostConstants {
    static let typeKey = "Post"
    static let captionKey = "caption"
    static let timeStampKey = "timeStamp"
    static let commentsKey = "comments"
    static let photoKey = "photo"
    static let commentCountKey = "commentCount"
}

class Post {
    var photoData: Data?
    let timeStamp: Date
    let caption: String
    var comments: [Comment]
    let recordID: CKRecord.ID
    var commentCount: Int
    
    var photo: UIImage? {
        get {
            guard let photoData = photoData else {return nil}
            return UIImage(data: photoData)
        }
        set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    var imageAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectURL = URL(fileURLWithPath: tempDirectory)
            let fileUrl = tempDirectURL.appendingPathComponent(recordID.recordName).appendingPathExtension("jpg")
            do {
                try photoData?.write(to: fileUrl)
            } catch {
                print("error writing to file url \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileUrl)
        }
    }
    
    
    
    init(photo: UIImage, timeStamp: Date = Date(), caption: String, comment: [Comment] = [], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), commentCount: Int = 0) {
        self.timeStamp = timeStamp
        self.caption = caption
        self.comments = comment
        self.recordID = recordID
        self.commentCount = commentCount
        self.photo = photo
    }
    
    init?(ckRecord: CKRecord) {
        do {
            guard let caption = ckRecord[PostConstants.captionKey] as? String,
                let timestamp = ckRecord[PostConstants.timeStampKey] as? Date,
                let commentCount = ckRecord[PostConstants.commentCountKey] as? Int,
                let photoAsset = ckRecord[PostConstants.photoKey] as? CKAsset
                else { return nil }
            
            let photoData = try Data(contentsOf: photoAsset.fileURL!)
            self.caption = caption
            self.timeStamp = timestamp
            self.commentCount = commentCount
            self.comments = []
            self.photoData = photoData
            self.recordID = ckRecord.recordID
            
        }catch {
            print("error at post failable init \(error.localizedDescription)")
            return nil
        }
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

