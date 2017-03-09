//
//  Book.swift
//  NDTextbookExchange
//
//  Created by Katie Kuenster on 3/9/17.
//  Copyright © 2017 CSE40814. All rights reserved.
//

import Foundation
import UIKit

class Book {
    
    var title: String
    var author: String
    var isbn: String
    var seller: String
    var desc: String
    var image: String?
    var placeholderimage: UIImage = #imageLiteral(resourceName: "placeholder")
    
    init (title: String, author: String, isbn: String, seller: String, desc: String, image: String){
        self.title = title
        self.author = author
        self.isbn = isbn
        self.seller = seller
        self.desc = desc
        self.image = image
    }
    
}