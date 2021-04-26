//
//  OrderDetialTableViewCell.swift
//  demoDrink
//
//  Created by YA on 2021/4/25.
//

import UIKit

class OrderDetialTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var menu: UILabel!
    @IBOutlet weak var ice: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var sweet: UILabel!
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var feed: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var remarks: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
