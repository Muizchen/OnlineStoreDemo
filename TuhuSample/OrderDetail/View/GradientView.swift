//
//  GradientView.swift
//  TuhuSample
//
//  Created by Muiz on 15/07/2019.
//  Copyright © 2019 BearCookies. All rights reserved.
//

import Foundation

class GradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

class GradientLayer: CAGradientLayer {
    
    init(frame: CGRect) {
        super.init()
        self.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func colors(_ colors: [UIColor]) -> GradientLayer {
        self.colors = colors.map { $0.cgColor }
        return self
    }
    
    func cornerRadius(_ radius: CGFloat) -> GradientLayer {
        cornerRadius = radius
        masksToBounds = true
        return self
    }
    
    func border(_ width: CGFloat) -> GradientLayer {
        borderWidth = width
        return self
    }
    
    func border(_ color: UIColor) -> GradientLayer {
        borderColor = color.cgColor
        return self
    }
    
    func frame(_ frame: CGRect) -> GradientLayer {
        self.frame = frame
        return self
    }
    
}
