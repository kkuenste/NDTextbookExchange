//
//  SearchTableViewController.swift
//  NDTextbookExchange
//
//  Created by Katie Kuenster on 2/13/17.
//  Copyright © 2017 CSE40814. All rights reserved.
//

import UIKit
import Parse
import Nuke

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
                self.books.removeAll()
                //self.books = objects!
                for obj in objects! {
                    if let title = obj["title"], let author = obj["author"], let isbn = obj["ISBN"], let seller = obj["seller"], let desc = obj["description"], let price = obj["price"], let image = obj["image"], let objectId = obj.objectId {
                        self.books.append(Book(title: title as! String, author: author as! String, isbn: isbn as! String, seller: seller as! String, desc: desc as! String, price: price as! String, image: image as! String, objectId: objectId))
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
        //self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Apple SD Gothic Neo", size: 17)!]
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["Title", "ISBN"]
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.1449598968, green: 0.4179388881, blue: 0.6258006096, alpha: 1)
        
        self.tableView.separatorColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
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
                bookCell.priceLabel.text = "$\(filteredBooks[indexPath.row].price)"
                
                let url = NSURL(string: (self.filteredBooks[indexPath.row].image)!) as! URL
                Nuke.loadImage(with: url, into: bookCell.bookImage)

            } else {
                bookCell.titleLabel.text = books[indexPath.row].title
                bookCell.isbnLabel.text = books[indexPath.row].isbn
                bookCell.sellerLabel.text = books[indexPath.row].seller
                bookCell.authorLabel.text = books[indexPath.row].author
                bookCell.bookImage.image = books[indexPath.row].placeholderimage
                bookCell.priceLabel.text = "$\(books[indexPath.row].price)"
                
                let url = NSURL(string: (self.books[indexPath.row].image)!) as! URL
                Nuke.loadImage(with: url, into: bookCell.bookImage)
            }

        }

        return cell
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String) {

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? BookDetailViewController, let indexPath = tableView.indexPathForSelectedRow {
            if searchController.isActive && searchController.searchBar.text != "" {
                dest.bookTitle = self.filteredBooks[indexPath.row].title
                dest.url = NSURL(string: (self.filteredBooks[indexPath.row].image)!) as! URL
                dest.author = self.filteredBooks[indexPath.row].author
                dest.isbn = self.filteredBooks[indexPath.row].isbn
                dest.seller = self.filteredBooks[indexPath.row].seller
                dest.price = self.filteredBooks[indexPath.row].price
                dest.descText = self.filteredBooks[indexPath.row].desc
                dest.objectId = self.filteredBooks[indexPath.row].objectId
            } else {
                dest.bookTitle = self.books[indexPath.row].title
                dest.url = NSURL(string: (self.books[indexPath.row].image)!) as! URL
                dest.author = self.books[indexPath.row].author
                dest.isbn = self.books[indexPath.row].isbn
                dest.seller = self.books[indexPath.row].seller
                dest.price = self.books[indexPath.row].price
                dest.descText = self.books[indexPath.row].desc
                dest.objectId = self.books[indexPath.row].objectId
            }
        }
    }


}
