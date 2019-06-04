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
    @IBOutlet weak var postCaptionLabel: UILabel!
    @IBOutlet weak var postCommentNumber: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let post = post else {return}
        postImageView.image = post.photo
        postCaptionLabel.text = post.caption
        postCommentNumber.text = "\(post.comment.count)"
        commentTextField.text = ""

    }

    @IBAction func commentAddButtonTapped(_ sender: Any) {
        guard let text = commentTextField.text, let post = post else {return}
        if text.isEmpty {
            return
        }
        PostController.shared.addComment(text: text, post: post) { (comment) in
            
        }
        tableView.reloadData()
        commentTextField.text = ""
    }
    
    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return post?.comment.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)

        // Configure the cell...
        guard let currentComment = post?.comment[indexPath.row] else {return UITableViewCell()}
        
        cell.textLabel?.text = "\(String(describing: currentComment.timeStamp))"
        cell.detailTextLabel?.text = currentComment.comment
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}