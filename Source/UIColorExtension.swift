
//
//  UIColorExtension.swift
//  DYZB
//
//  Created by  bochb on 2017/12/13.
//  Copyright © 2017年 com.heron. All rights reserved.
//

import UIKit

extension UIColor {
    
   public static func randomColor() -> UIColor {
        let r = CGFloat(arc4random_uniform(255)) / 255.0
        let g = CGFloat(arc4random_uniform(255)) / 255.0
        let b = CGFloat(arc4random_uniform(255)) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }

    
    /// 十六进制颜色
    ///
    /// - Parameters:
    ///   - hex:
    ///   - alpha: 
   public convenience init(hex: UInt, alpha: CGFloat) {
        self.init(red: CGFloat((hex >> 16) & (0xFF)) / 255.0, green: CGFloat((hex >> 8) & 0xFF) / 255.0, blue: CGFloat(hex & 0xFF) / 255.0, alpha: alpha)
    }
    
    
    /// 获取颜色的RGBA值
   public func getRGB() -> (red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat ) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r,g,b,a)
        }
        return (0.0, 0.0, 0.0, 0.0)
    }
}
