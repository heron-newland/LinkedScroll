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
    
    /// title滑动
    @objc optional func titleScrollViewDidScroll(titleScrollView: UIScrollView)
    
    ///title即将结束滑动
    @objc optional  func titleScrollViewWillBeginDecelerating(titleScrollView: UIScrollView)
    
    ///title结束滑动
    @objc optional  func titleScrollViewDidEndDecelerating(titleScrollView: UIScrollView)
    
    ///title停止拖动
    @objc optional  func titleScrollViewDidEndDragging(titleScrollView: UIScrollView, willDecelerate decelerate: Bool)
    
    ///title开始拖动
    @objc optional  func titleScrollViewWillBeginDragging(titleScrollView: UIScrollView)
    
    
    //content
    ///content滑动
    @objc optional func contentScrollViewDidScroll(contentScrollView: UIScrollView)
    
    ///content即将结束滑动
    @objc optional  func contentScrollViewWillBeginDecelerating(contentScrollView: UIScrollView)
    
    ///content结束滑动
    @objc optional  func contentScrollViewDidEndDecelerating(contentScrollView: UIScrollView)
    
    ///content停止拖动
    @objc optional  func contentScrollViewDidEndDragging(contentScrollView: UIScrollView, willDecelerate decelerate: Bool)
    
    ///content开始拖动
    @objc optional  func contentScrollViewWillBeginDragging(contentScrollView: UIScrollView)
    
    
    
//    @objc optional func loadMoreData(contentScrollView: HLLScrollContentView)
}
