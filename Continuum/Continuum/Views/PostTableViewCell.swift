//
//  PostTableViewCell.swift
//  Continuum
//
//  Created by William Moody on 6/4/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postCaptionLable: UILabel!
    @IBOutlet weak var postCommentLabel: UILabel!
    
    var post: Post? {
        didSet{
            updateCell()
        }
    }
    
    func updateCell() {
        guard let post = post else {return}
        postImageView.image = post.photo
        postCaptionLable.text = post.caption
        postCommentLabel.text = "\(post.comment.count)"
    }
    
}
