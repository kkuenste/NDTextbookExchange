//
//  SearchTableViewController.swift
//  NDTextbookExchange
//
//  Created by Katie Kuenster on 2/13/17.
//  Copyright © 2017 CSE40814. All rights reserved.
//

import UIKit
import Parse

class SearchTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    var user = User()
    var books = [Book]()
    var filteredBooks = [Book]()
    let searchController = UISearchController(searchResultsController: nil)

    @IBAction func logoutButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let query = PFQuery(className: "Book")
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                //self.books = objects!
                for obj in objects! {
                    if let title = obj["title"], let author = obj["author"], let isbn = obj["ISBN"], let seller = obj["seller"], let desc = obj["description"] , let image = obj["image"] {
                        self.books.append(Book(title: title as! String, author: author as! String, isbn: isbn as! String, seller: seller as! String, desc: desc as! String, image: image as! String))
                    }
                }
                self.tableView.reloadData()
            }
            else {
                NSLog("Error: \(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["Title", "ISBN"]
        tableView.tableHeaderView = searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredBooks.count
        }
        NSLog("count: \(books.count)")
        return books.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let bookCell = cell as? BookTableViewCell  {
            if searchController.isActive && searchController.searchBar.text != "" {
                bookCell.titleLabel.text = filteredBooks[indexPath.row].title
                bookCell.isbnLabel.text = filteredBooks[indexPath.row].isbn
                bookCell.sellerLabel.text = filteredBooks[indexPath.row].seller
                bookCell.authorLabel.text = filteredBooks[indexPath.row].author
                bookCell.bookImage.image = filteredBooks[indexPath.row].placeholderimage

                
                DispatchQueue.main.async(execute: {
                    if let imageURL = self.filteredBooks[indexPath.row].image {
                        if let url = NSURL(string: imageURL) {
                            if let data = NSData(contentsOf: url as URL) {
                                bookCell.bookImage.image = UIImage(data: data as Data)
                            }
                        }
                    }
                })
            } else {
                bookCell.titleLabel.text = books[indexPath.row].title
                bookCell.isbnLabel.text = books[indexPath.row].isbn
                bookCell.sellerLabel.text = books[indexPath.row].seller
                bookCell.authorLabel.text = books[indexPath.row].author
                bookCell.bookImage.image = books[indexPath.row].placeholderimage
            
                DispatchQueue.main.async(execute: {
                    if let imageURL = self.books[indexPath.row].image {
                        if let url = NSURL(string: imageURL) {
                            if let data = NSData(contentsOf: url as URL) {
                                bookCell.bookImage.image = UIImage(data: data as Data)
                            }
                        }
                    }
                })
            }

        }

        return cell
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String) {
        //filteredBooks.removeAll()
        /*var searchStr = ""
        if (scope == "Title") {
            searchStr = "title"
        } else {
            searchStr = "ISBN"
        }
        let query = PFQuery(className: "Book")
        query.whereKey(searchStr, contains: searchText)
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                self.filteredBooks = objects!
                self.tableView.reloadData()
            }
            else {
                NSLog("Error: \(error)")
            }
        }
        */
        /*
        if scope == "Title" {
            for book in self.books {
                if book.title.lowercased().range(of: searchText.lowercased()) != nil {
                    filteredBooks.append(book)
                }
            }
        } else { // isbn
            for book in self.books {
                if book.isbn.range(of: searchText) != nil {
                    filteredBooks.append(book)
                }
            }
        }*/

        filteredBooks = books.filter({( book : Book) -> Bool in
            if scope == "Title" {
                return book.title.lowercased().contains(searchText.lowercased())

            } else {
                return book.isbn.lowercased().contains(searchText.lowercased())

            }
        })
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
            filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
