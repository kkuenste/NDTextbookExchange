//
//  User.swift
//  NDTextbookExchange
//
//  Created by Katie Kuenster on 2/14/17.
//  Copyright © 2017 CSE40814. All rights reserved.
//

import Foundation

class User {
    
    var email: String
    var password: String
    var name: String
    var venmo: String
    
    init ( email: String, password: String, name: String, venmo: String ) {
        self.email = email
        self.password = password
        self.name = name
        self.venmo = venmo
    }
    
    init () {
        self.email = ""
        self.password = ""
        self.name = ""
        self.venmo = ""
    }
    
}

