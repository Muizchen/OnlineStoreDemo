//
//  TrackingBubbleView.swift
//  TuhuSample
//
//  Created by Muiz on 2019/6/13.
//  Copyright © 2019 BearCookies. All rights reserved.
//

import Foundation

enum TrackingAnnotationType: String {
    case addresser = "发"
    case receiver = "收"
    case deliver = ""
}

class TrackingAnnotationView: UIView {
    
    public var cornerRadius: CGFloat
    public var address: String        // 如：上海仓库
    public var annotationType: TrackingAnnotationType
    
    private var shadowRadius: CGFloat = 2
    
    init(address: String, type: TrackingAnnotationType = .deliver, cornerRadius: CGFloat = 4) {
        self.address = address
        self.annotationType = type
        self.cornerRadius = cornerRadius
        super.init(frame: CGRect.zero)
        
        self.layoutWithContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutWithContent() {
        isOpaque = false
        // Calculate the displaying rect
        let addressLabel = UILabel()
        addressLabel.text = address
        addressLabel.font = UIFont.systemFont(ofSize: 10)
        addressLabel.textColor = UIColor.tuhu.textBlack
        let addressWidth = addressLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 14)).width
        addressLabel.frame = CGRect(x: shadowRadius + 30, y: shadowRadius + 5, width: addressWidth, height: 15)
        addSubview(addressLabel)
        
        let abbreviationLabel = UILabel(frame: CGRect(x: shadowRadius + 6, y: shadowRadius + 3, width: 12, height: 17))
        abbreviationLabel.text = annotationType.rawValue
        abbreviationLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        if self.annotationType == .addresser {
            abbreviationLabel.textColor = UIColor.tuhu.red
        } else {
            abbreviationLabel.textColor = .white
        }
        addSubview(abbreviationLabel)
        
        let viewWidth: CGFloat = 24.0 + 12.0 + addressWidth
        
        // 左右上各2的阴影距离
        self.frame = CGRect(x: 2, y: 2, width: viewWidth + 4, height: 32 + 14)
    }
    
    override func draw(_ rect: CGRect) {
        //// General Declarations
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        //// Shadow Declarations
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.27)
        shadow.shadowOffset = CGSize(width: 0, height: 0)
        shadow.shadowBlurRadius = shadowRadius
        
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: shadowRadius, y: shadowRadius, width: rect.width - 2 * shadowRadius, height: 24), byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        bezierPath.move(to: CGPoint(x: rect.midX - 5.0, y: shadowRadius + 24))
        bezierPath.addLine(to: CGPoint(x: rect.midX, y: shadowRadius + 24 + 5))
        bezierPath.addLine(to: CGPoint(x: rect.midX + 5.0, y: shadowRadius + 24))
        
        bezierPath.close()
        context.saveGState()
        context.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: (shadow.shadowColor as! UIColor).cgColor)
        UIColor.white.setFill()
        bezierPath.fill()
        
        // AbbreviationView
        let abbreviationPath = UIBezierPath(roundedRect: CGRect(x: shadowRadius, y: shadowRadius, width: 24, height: 24), byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        if self.annotationType == .addresser {
            UIColor(hex: 0xDF3348, alpha: 0.18).setFill()
        } else {
            UIColor(hex: 0xDF3348).setFill()
        }
        abbreviationPath.fill()
        
        let outerRoundPath = UIBezierPath(roundedRect: CGRect(x: rect.midX - 7, y: rect.maxY - 14, width: 14, height: 14), cornerRadius: 7)
        if self.annotationType == .addresser {
            UIColor.tuhu.red.setFill()
            outerRoundPath.fill()
            let innerRoundPath = UIBezierPath(roundedRect: CGRect(x: rect.midX - 3, y: rect.maxY - 10, width: 6, height: 6), cornerRadius: 3)
            UIColor.white.setFill()
            innerRoundPath.fill()
        } else {
            UIColor(hex: 0xFE8594).setFill()
            outerRoundPath.fill()
        }
        
        context.restoreGState()
    }
    
    var image: UIImage? {
        guard self.annotationType != .deliver else {
            return imageResize(image: #imageLiteral(resourceName: "location"))
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.bounds.width, height: self.bounds.height * 1.6), false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return img
        }
        return nil
    }
    
    private func imageResize (image: UIImage) -> UIImage? {
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        let changedSize = CGSize(width: image.size.width, height: image.size.height * 1.6)
        
        UIGraphicsBeginImageContextWithOptions(changedSize, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
}
