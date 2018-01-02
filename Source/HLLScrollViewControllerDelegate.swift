
//
//  HLLScrollViewControllerDelegate.swift
//  DYZB
//
//  Created by  bochb on 2017/12/15.
//  Copyright © 2017年 com.heron. All rights reserved.
//

import UIKit

 protocol HLLScrollViewControllerDelegate: NSObjectProtocol{

    /// 选中title中某个label
    ///
    /// - Parameters:
    ///   - titleView:
    ///   - index: 选中的label的下标
    func scrollviewTitleView(titleView: HLLScrollTitleView, didSelect index: Int)
    
    /// collection滚动的代理
    ///
    /// - Parameters:
    ///   - contentView:
    ///   - fromIndex: 起始index
    ///   - toIndex: 目的index
    ///   - progress: 滚动进度, 0 - 1
    func scrollContentView(contentView: HLLScrollContentView, scroll fromIndex: Int, toIndex: Int, progress: CGFloat)

}
