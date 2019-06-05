//
//  PostDetailTableViewController.swift
//  Continuum
//
//  Created by William Moody on 6/4/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var followPostButton: UIButton!
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    var post: Post? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func updateViews () {
        guard let post = post else {return}
        postImageView.image = post.photo
        tableView.reloadData()
        updateFollowPostButton()
    }
    
    func updateFollowPostButton() {
        guard let post = post else {return}
        //
    }
    
    func presentCommentAlertController() {
        
        let alertController = UIAlertController(title: "Add Comment", message: "Write what you want", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "witty comment here"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let commentAction =  UIAlertAction(title: "Comment", style: .default) { (_) in
            guard let commentText = alertController.textFields?.first?.text,
            !commentText.isEmpty,
                let post = self.post else {return}
            PostController.shared.addComment(text: commentText, post: post, completion: { (comment) in
            })
            self.tableView.reloadData()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(commentAction)
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func commentButtonTapped(_ sender: Any) {
        presentCommentAlertController()
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        guard let comment = post?.caption else { return }
        let shareSheet = UIActivityViewController(activityItems: [comment], applicationActivities: nil)
        present(shareSheet, animated: true, completion: nil)
    }
    
    @IBAction func followButtonTapped(_ sender: Any) {
        guard let post = post else {return}
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return post?.comments.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)

        // Configure the cell...
        guard let currentComment = post?.comments[indexPath.row] else {return UITableViewCell()}
        
        cell.textLabel?.text = currentComment.comment
        cell.detailTextLabel?.text = currentComment.timeStamp.stringWith(dateStyle: .medium, timeStyle: .short)
        
        return cell
    }

}
