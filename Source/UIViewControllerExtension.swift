//
//  UIViewControllerExtension.swift
//  DYZB
//
//  Created by  bochb on 2017/12/13.
//  Copyright © 2017年 com.heron. All rights reserved.
//

import UIKit

extension UIViewController {

    
     /// 获取导航栏高度
    public func navigateBarHeight() -> CGFloat {
        guard let navi = self.navigationController else { return 0 }
        if navi.navigationBar.isHidden {
            return 0
        }
        return navi.navigationBar.frame.height
    }
    
    /// 获取tabbar高度
   public func tabBarHeight() -> CGFloat {
        guard let barVC = self.tabBarController else { return 0 }
        if barVC.tabBar.isHidden {
            return 0
        }
        return barVC.tabBar.frame.height
    }
    
    /// 安全区域
    ///
    /// - Returns: 
   public func safeAreaInset() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
        return view.safeAreaInsets
        }
        
        return UIEdgeInsetsMake(UIApplication.getStatusBarHeight() + self.navigateBarHeight(), 0, self.tabBarHeight(), 0)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
