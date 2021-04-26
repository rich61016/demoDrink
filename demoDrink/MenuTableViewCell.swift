//
//  MenuTableViewCell.swift
//  demoDrink
//
//  Created by YA on 2021/4/24.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceMLabel: UILabel!
    @IBOutlet weak var priceLLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
