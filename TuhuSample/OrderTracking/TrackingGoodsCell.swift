//
//  TrackingGoodsCell.swift
//  Tuhu
//
//  Created by Muiz on 2019/6/11.
//  Copyright © 2019 Tuhu. All rights reserved.
//

import UIKit

class TrackingGoodsCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var deliveryNumberLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var productCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func copyDeliveryNumber(_ sender: Any) {
        
    }
    
}
