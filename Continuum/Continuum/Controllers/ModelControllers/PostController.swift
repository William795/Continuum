//
//  PostController.swift
//  Continuum
//
//  Created by William Moody on 6/4/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import UIKit
import CloudKit


class PostController {
    
    static let shared = PostController()
    private init(){
        subscripeToNewPosts(completion: nil)
    }
    var posts: [Post] = []
    let publicDB = CKContainer.default().publicCloudDatabase
    //CRUD
    func addComment(text: String, post: Post, completion: @escaping (Comment?) -> () ) {
        //make and append new comment
        let newComment = Comment(comment: text, post: post)
        post.comments.append(newComment)
        
        let record = CKRecord(comment: newComment)
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("add comment🚒🚒🚒🚒🚒\(error.localizedDescription) \(error) in function: \(#function)🚒🚒🚒🚒🚒")
                completion(nil)
                return
            }
            guard let record = record else {return}
            let comment = Comment(ckRecord: record, post: post)
            self.incrementCommentCounter(for: post, completion: nil)
            completion(comment)
        }
    }
    
    func createPostWith(image: UIImage, caption: String, completion: @escaping (Post?) -> ()) {
        let newPost = Post(photo: image, caption: caption)
        posts.append(newPost)
        let record = CKRecord(post: newPost)
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("create post🚒🚒🚒🚒🚒\(error.localizedDescription) \(error) in function: \(#function)🚒🚒🚒🚒🚒")
                completion(nil)
                return
            }
            guard let record = record,
                let post = Post(ckRecord: record) else {return}
            completion(post)
        }
    }
    
    func fetchPosts(completion: @escaping ([Post]?) -> ()){
        let predicate = NSPredicate(value: true)
        let querry = CKQuery(recordType: PostConstants.typeKey, predicate: predicate)
        publicDB.perform(querry, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("fetch post🚒🚒🚒🚒🚒\(error.localizedDescription) \(error) in function: \(#function)🚒🚒🚒🚒🚒")
                completion(nil)
                return
            }
            guard let records = records else {return}
            let posts = records.compactMap { Post(ckRecord: $0)}
            self.posts = posts
            completion(posts)
        }
    }
    
    func fetchComments(for post: Post, completion: @escaping ([Comment]?) -> ()) {
        let postReference = post.recordID
        
        //This is a predicate (filter) for all of the comments in CloudKit which have this postReference
        let predicate = NSPredicate(format: "%K == %@", commentConstants.postReferenceKey, postReference)
        let commentIDs = post.comments.compactMap({$0.recordID})
        //This is a predicate (filter) which excludes all of the comments we already have storeds within the local post.  This allows us to not refetch comments we already have pulled down.
        
        let predicate2 = NSPredicate(format: "NOT(recordID IN %@)", commentIDs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
        let querry = CKQuery(recordType: "Comment", predicate: compoundPredicate)
        
        publicDB.perform(querry, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("fetch comment🚒🚒🚒🚒🚒\(error.localizedDescription) \(error) in function: \(#function)🚒🚒🚒🚒🚒")
                completion(nil)
                return
            }
            guard let records = records else {return}
            let comments = records.compactMap{ Comment(ckRecord: $0, post: post)}
            post.comments.append(contentsOf: comments)
            completion(comments)
        }
    }
    
    func incrementCommentCounter(for post: Post, completion: ((Bool) -> Void)?) {
        //local commentcount increment
        post.commentCount += 1
        //modify in cloud
        let modifyOperation = CKModifyRecordsOperation(recordsToSave: [CKRecord(post: post)], recordIDsToDelete: nil)
        //only modifys what has been changed
        modifyOperation.savePolicy = .changedKeys
        
        modifyOperation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                print("comment increment🚒🚒🚒🚒🚒\(error.localizedDescription) \(error) in function: \(#function)🚒🚒🚒🚒🚒")
                completion?(false)
                return
            }else {
                completion?(true)
            }
        }
        //add oberation to public database
        publicDB.add(modifyOperation)
    }
    
    func subscripeToNewPosts(completion: ((Bool, Error?) -> Void)?) {
        let predicate = NSPredicate(value: true)
        
        //creating subsiption for allPost record creations
        let subscription = CKQuerySubscription(recordType: "Post", predicate: predicate, subscriptionID: "AllPosts", options: CKQuerySubscription.Options.firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.alertBody = "New Post Added to Continuum"
        notificationInfo.shouldBadge = true
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        
        publicDB.save(subscription) { (sub, error) in
            if let error = error {
                print("sub save🚒🚒🚒🚒🚒\(error.localizedDescription) \(error) in function: \(#function)🚒🚒🚒🚒🚒")
                completion?(false, error)
            }else {
                completion?(true, nil)
            }
        }
    }
    
    func addSubscritptionTo(commentsForPost post: Post, completion: ((Bool, Error?) -> Void)?) {
        let postRecordID = post.recordID
        let predicate = NSPredicate(format: "%K == %@", commentConstants.postReferenceKey, postRecordID)
        
        let subscription = CKQuerySubscription(recordType: "Comment", predicate: predicate, subscriptionID: post.recordID.recordName, options: CKQuerySubscription.Options.firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.alertBody = "A new comment was added a a post you follow!"
        notificationInfo.shouldSendContentAvailable = true
        notificationInfo.desiredKeys = nil
        subscription.notificationInfo = notificationInfo
        
        publicDB.save(subscription) { (record, error) in
            if let error = error {
                print("sub add🚒🚒🚒🚒🚒\(error.localizedDescription) \(error) in function: \(#function)🚒🚒🚒🚒🚒")
                completion?(false, error)
            }else {
                completion?(true, nil)
            }
        }
    }
    
    func removeSubscriptionTo(commentsForPost post: Post, completion: ((Bool) -> Void)?) {
        let subscriptionID = post.recordID.recordName
        
        publicDB.delete(withSubscriptionID: subscriptionID) { (_, error) in
            if let error = error {
                print("error removing sub🚒🚒🚒🚒🚒\(error.localizedDescription) \(error) in function: \(#function)🚒🚒🚒🚒🚒")
                completion?(false)
                return
            }else {
                completion?(true)
            }
        }
    }
    
    func checkForSubscription(to post: Post, completion: ((Bool) -> ())?) {
        let subscriptionID = post.recordID.recordName
        
        publicDB.fetch(withSubscriptionID: subscriptionID) { (subscription, error) in
            if let error = error {
                print("sub check🚒🚒🚒🚒🚒\(error.localizedDescription) \(error) in function: \(#function)🚒🚒🚒🚒🚒")
                completion?(false)
                return
            }
            if subscription != nil {
                completion?(true)
            }else {
                completion?(false)
            }
        }
    }
    
    func toggleSubscriptionTo(commentForPost post: Post, completion: ((Bool, Error?) -> ())?) {
        // checks for sub to determine if we should add or remove
        checkForSubscription(to: post) { (isSub) in
            if isSub {
                self.removeSubscriptionTo(commentsForPost: post, completion: { (success) in
                    if success {
                        print("sub removed")
                        completion?(true, nil)
                    }else {
                        print("failed to remove sub")
                        completion?(false, nil)
                    }
                })
            }else {
                self.addSubscritptionTo(commentsForPost: post, completion: { (success, error) in
                    if let error = error {
                        print("toggle add🚒🚒🚒🚒🚒\(error.localizedDescription) \(error) in function: \(#function)🚒🚒🚒🚒🚒")
                        completion?(false, error)
                        return
                    }
                    if success {
                        print("added sub")
                        completion?(true, nil)
                    }else {
                        print("failed to add sub")
                        completion?(false, nil)
                    }
                })
            }
        }
    }
}
