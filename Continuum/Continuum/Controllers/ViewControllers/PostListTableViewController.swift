//
//  PostListTableViewController.swift
//  Continuum
//
//  Created by William Moody on 6/4/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {

    @IBOutlet weak var postSearchBar: UISearchBar!
    
    var resultsArray: [SearchableRecord] = []
    var isSearching = false
    var dataSource: [SearchableRecord] {
        return isSearching ? resultsArray : PostController.shared.posts
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postSearchBar.delegate = self
        performFullSync(completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {
            self.resultsArray = PostController.shared.posts
            self.tableView.reloadData()
        }
    }



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell
        let post = dataSource[indexPath.row] as? Post
        cell?.post = post

        return cell ?? UITableViewCell()
    }
    
    func performFullSync(completion: ((Bool) -> Void)?){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        PostController.shared.fetchPosts { (posts) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.tableView.reloadData()
                completion?(posts != nil)
            }
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postDetailSegue"  {
            let destinationVC = segue.destination as? PostDetailTableViewController
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let post = PostController.shared.posts[indexPath.row]
            destinationVC?.post = post
        }
    }
}

extension PostListTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultsArray = PostController.shared.posts.filter { $0.matches(searchTerm: searchText) }
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultsArray = PostController.shared.posts
        tableView.reloadData()
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
}
