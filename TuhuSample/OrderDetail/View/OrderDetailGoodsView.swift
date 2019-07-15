//
//  OrderDetailGoodsView.swift
//  TuhuSample
//
//  Created by Muiz on 15/07/2019.
//  Copyright © 2019 BearCookies. All rights reserved.
//

import UIKit

class OrderDetailGoodsView: UIView {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 86))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func loadFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        if let view = bundle.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }
    }
    
    public var goods = GoodsModel() {
        didSet {
            // Todo
            // self.iconImageView.
            self.nameLabel.attributedText = NSAttributedString(string: goods.name, attributes: [.foregroundColor: UIColor.tuhu.black])
            self.priceLabel.text = "￥\(goods.price)"
            self.countLabel.text = "X\(goods.count)"
        }
    }
    
}
