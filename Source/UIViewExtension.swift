
//
//  UIViewExtension.swift
//  Demo
//
//  Created by  bochb on 2017/12/21.
//  Copyright © 2017年 com.heron. All rights reserved.
//

import UIKit

extension UIView{
    /// 安全区域
    ///
    /// - Returns:
    func safeAreaInset() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return safeAreaInsets
        }
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
}
