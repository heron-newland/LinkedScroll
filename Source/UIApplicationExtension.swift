//
//  UIApplicationExtension.swift
//  DYZB
//
//  Created by  bochb on 2017/12/19.
//  Copyright © 2017年 com.heron. All rights reserved.
//

import UIKit

extension UIApplication {
    static func getStatusBarHeight() -> CGFloat {
        if UIApplication.shared.isStatusBarHidden {
            return 0
        }
        return UIApplication.shared.statusBarFrame.height
    }
}

    

