//
//  HLLScrollViewDelegate.swift
//  DYZB
//
//  Created by  bochb on 2017/12/18.
//  Copyright © 2017年 com.heron. All rights reserved.
//

import UIKit

@objc public protocol HLLScrollViewDelegate: NSObjectProtocol{
    
    /// title被点击
    ///
    /// - Parameters:
    ///   - titleScrollView: 标题view
    ///   - titleLabel: 被点击的label
    ///   - tappedIndex: 被点击label的下标
    @objc optional func titleScrollView(titleScrollView: UIScrollView, titleLabel: HLLTitleView, tappedIndex: Int)
   
    
    @objc optional func titleScrollViewDidScroll(titleScrollView: UIScrollView)
    
  
    @objc optional  func titleScrollViewDidEndDecelerating(titleScrollView: UIScrollView)
    @objc optional  func titleScrollViewDidEndDragging(titleScrollView: UIScrollView, willDecelerate decelerate: Bool)
    @objc optional  func titleScrollViewWillBeginDragging(titleScrollView: UIScrollView)
    @objc optional  func titleScrollViewWillBeginDecelerating(titleScrollView: UIScrollView)
    
    //content
    @objc optional func contentScrollViewDidScroll(contentScrollView: UIScrollView)
    @objc optional  func contentScrollViewDidEndDecelerating(contentScrollView: UIScrollView)
    @objc optional  func contentScrollViewDidEndDragging(contentScrollView: UIScrollView, willDecelerate decelerate: Bool)
    @objc optional  func contentScrollViewWillBeginDragging(contentScrollView: UIScrollView)
    @objc optional  func contentScrollViewWillBeginDecelerating(contentScrollView: UIScrollView)
}
