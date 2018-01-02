//
//  HLLScrollViewDataSource.swift
//  DYZB
//
//  Created by  bochb on 2017/12/18.
//  Copyright © 2017年 com.heron. All rights reserved.
//

import UIKit

public protocol HLLScrollViewDataSource:  NSObjectProtocol {
    
    /// 标题视图的数据源,
    ///
    /// - Parameter viewController: HLLScrollViewController
    /// - Returns: 标题数组
    func scrollTitles(for scrollView: HLLScrollView?) -> [String]
    
    /// 内容视图的数据源
    ///
    /// - Parameter viewController: HLLScrollViewController
    /// - Returns: 内容控制器数组
    func scrollContentViewControllers(for scrollView: HLLScrollView?) -> [UIViewController]
    
    func scrollContentParentViewController(for scrollView: HLLScrollView?) -> UIViewController?
}

extension HLLScrollViewDataSource{
    func scrollContentParentViewController(for scrollView: HLLScrollView?) -> UIViewController?{
        return nil
    }
}
