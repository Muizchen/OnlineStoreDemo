//
//  File.swift
//  TuhuSample
//
//  Created by Muiz on 2019/6/13.
//  Copyright © 2019 BearCookies. All rights reserved.
//

import Foundation

extension UIColor {
    
    static var tuhu = TuhuColor.self
    
    @objc public convenience init(hex: UInt32, alpha: CGFloat = 1) {
        self.init(red: CGFloat((hex & 0xFF0000) >> 16)/255, green: CGFloat((hex & 0x00FF00) >> 8)/255, blue: CGFloat(hex & 0x0000FF)/255, alpha: alpha)
    }
    
    @objc public convenience init(hexString: String, alpha: CGFloat = 1) {
        var temp = hexString.uppercased()
        if temp.hasPrefix("#") {
            temp = temp.replacingOccurrences(of: "#", with: "")
        }
        
        switch temp.count {
        case 6:
            self.init(hex: UInt32(hexString.hexInteger), alpha: alpha)
        case 3:
            self.init(hex3: hexString.hexInteger, alpha: alpha)
        default:
            self.init(hex: 0x000000)
        }
    }
    
    @objc private convenience init(hex3 hex: Int, alpha: CGFloat) {
        func duplicate4bits(_ i: Int) -> Int {
            return (i << 4) + i
        }
        self.init(red: CGFloat(duplicate4bits((hex & 0xF00) >> 8))/255,
                  green: CGFloat(duplicate4bits((hex & 0x0F0) >> 4))/255,
                  blue: CGFloat(duplicate4bits(hex & 0x00F))/255,
                  alpha: alpha)
    }
    
}

class TuhuColor {
    static var white = UIColor(hexString: "fff")
    static var black = UIColor(hexString: "000")
    static var buttonBlack = UIColor(hexString: "222").withAlphaComponent(0.9)
    /**
     *333 / (51, 51, 51)
     */
    static var textBlack = UIColor(hexString: "333")
    /**
     *666
     */
    static var textDarkGray = UIColor(hexString: "666")
    /**
     *999 / (153, 153, 153)
     */
    static var textLightGray = UIColor(hexString: "999")
    /**
     *bf
     */
    static var textPlaceholder = UIColor(hexString: "bfbfbf")
    /**
     *d9
     */
    static var separator = UIColor(hexString: "d9d9d9")
    /**
     *eee
     */
    static var pageBackground = UIColor(hexString: "eee")
    /**
     *fd
     */
    static var barBackground = UIColor(hexString: "fdfdfd")
    static var red = UIColor(hexString: "df3348")
    static var green = UIColor(hexString: "47AB0F")
    static var orange = UIColor(hexString: "f57c33")
}

public extension String {
    
    /// 返回字符串所表示的十六进制数值，支持"#"标识符， 支持 "-" 号
    public var hexInteger: Int {
        var temp = self.uppercased()
        if temp.hasPrefix("#") {
            temp = temp.replacingOccurrences(of: "#", with: "")
        }
        var value = 0
        var negativeSign = 1
        var breakLoop = false
        for (idx, char) in temp.enumerated() {
            guard !breakLoop else { break }
            value *= 16
            switch char {
            case "-" where idx == 0:
                negativeSign = -1
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                value += Int(String(char))!
            case "A":
                value += 10
            case "B":
                value += 11
            case "C":
                value += 12
            case "D":
                value += 13
            case "E":
                value += 14
            case "F":
                value += 15
            default:
                breakLoop = true
            }
        }
        return value * negativeSign
    }
    
}

