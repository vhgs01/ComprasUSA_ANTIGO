//
//  ShoppingTableViewCell.swift
//  ComprasUSA
//
//  Created by Fellipe Soares Oliveira on 21/04/2018.
//  Copyright © 2018 Fellipe Soares Oliveira. All rights reserved.
//

import UIKit

class ShoppingTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var ivPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
