//
//  BatteryAddressInputCell.swift
//  TuhuSample
//
//  Created by Muiz on 24/07/2019.
//  Copyright © 2019 BearCookies. All rights reserved.
//

import UIKit

class BatteryAddressInputCell: UITableViewCell {

    @IBOutlet weak var typingLabel: UILabel!
    @IBOutlet weak var typingView: UIView!
    @IBOutlet weak var nearByView: UIView!
    
    private var paragraphStyle: NSParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 22
        style.lineBreakMode = .byCharWrapping
        return style
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(input: String) {
        if input.isEmpty {
            typingView.isHidden = true
            nearByView.isHidden = false
        } else {
            let attributedText = NSAttributedString(string: input, attributes: [.foregroundColor: UIColor.tuhu.textBlack, .paragraphStyle: paragraphStyle])
            typingLabel.attributedText = attributedText
            typingView.isHidden = false
            nearByView.isHidden = true
        }
    }
    
}
