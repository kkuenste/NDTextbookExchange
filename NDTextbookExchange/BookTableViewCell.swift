//
//  BookTableViewCell.swift
//  NDTextbookExchange
//
//  Created by Katie Kuenster on 3/7/17.
//  Copyright © 2017 CSE40814. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var isbnLabel: UILabel!
    @IBOutlet weak var sellerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
