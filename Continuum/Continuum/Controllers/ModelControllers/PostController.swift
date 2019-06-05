//
//  PostController.swift
//  Continuum
//
//  Created by William Moody on 6/4/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import UIKit


class PostController {
    
    static let shared = PostController()
    var posts: [Post] = []
    
    //CRUD
    func addComment(text: String, post: Post, completion: @escaping (Comment) -> () ) {
        //make new comment
        let newComment = Comment(comment: text, post: post)
        
        //append comment to post array
        post.comments.append(newComment)
    }
    
    func createPostWith(image: UIImage, caption: String, completion: @escaping (Post?) -> ()) {
        let newPost = Post(photo: image, timeStamp: Date(), caption: caption, comment: [])
        
        posts.append(newPost)
    }
    
    func fetchComments(for post: Post, completion: @escaping ([Comment]?) -> ()) {
        
    }
}
