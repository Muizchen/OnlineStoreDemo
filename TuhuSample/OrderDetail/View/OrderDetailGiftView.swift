//
//  OrderDetailGiftView.swift
//  TuhuSample
//
//  Created by Muiz on 16/07/2019.
//  Copyright © 2019 BearCookies. All rights reserved.
//

import UIKit

class OrderDetailGiftView: UIView {

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

}
