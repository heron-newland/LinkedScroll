//
//  HLLScrollViewController.swift
//  DYZB
//
//  Created by  bochb on 2017/12/15.
//  Copyright © 2017年 com.heron. All rights reserved.
//

import UIKit

open class HLLScrollViewController: UIViewController, HLLScrollViewDataSource, HLLScrollViewDelegate {

   private weak var dataSource: HLLScrollViewDataSource?
   private weak var delegate: HLLScrollViewDelegate?
    
    var titleViewHeight: CGFloat = 40.0{
        didSet{
           scrollContainer.titleViewHeight = titleViewHeight
        }
    }
    
   /// 初始化
   lazy var scrollContainer: HLLScrollView = {
        let scrollView = HLLScrollView()
        scrollView.dataSource = self
        scrollView.delegate = self
//        scrollView.titleView.textScaleRate = 0.2
//        scrollView.titleView.isIndicatorLineHidden = true
//        scrollView.titleView.textFont = UIFont.systemFont(ofSize: 20)
        scrollView.backgroundColor = UIColor.white
    return scrollView
    }()

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollContainer.frame = CGRect(x: 0, y: self.navigateBarHeight() + UIApplication.getStatusBarHeight(), width: view.bounds.width, height: view.bounds.height - self.navigateBarHeight() - self.tabBarHeight() - UIApplication.getStatusBarHeight())
        
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
       
       
        view.addSubview(scrollContainer)
    }
    
    //必需实现的数据源方法, 子类实现
    func scrollTitles(for scrollView: HLLScrollView?) -> [String] {
        assertionFailure("subClass must implement [scrollContentViewControllers] method")
        return [""]
    }
    
    func scrollContentViewControllers(for scrollView: HLLScrollView?) -> [UIViewController] {
        assertionFailure("subClass must implement [scrollContentViewControllers] method")
        return [UIViewController()]
    }
    
    public func scrollContentParentViewController(for scrollView: HLLScrollView?) -> UIViewController? {
        assertionFailure("subClass must implement [scrollContentParentViewController] method")
        return UIViewController()
    }
    
    //可选协议实现, 交给子类实现
    func titleScrollViewDidScroll(titleScrollView: UIScrollView) {}
    func titleScrollViewWillBeginDragging(titleScrollView: UIScrollView) {}
    func titleScrollViewDidEndDecelerating(titleScrollView: UIScrollView) {}
    func titleScrollViewWillBeginDecelerating(titleScrollView: UIScrollView) {}
    func titleScrollViewDidEndDragging(titleScrollView: UIScrollView, willDecelerate decelerate: Bool) {}
    func contentScrollViewDidScroll(contentScrollView: UIScrollView) {}
    func contentScrollViewWillBeginDragging(contentScrollView: UIScrollView) {}
    func contentScrollViewDidEndDecelerating(contentScrollView: UIScrollView) {}
    func contentScrollViewWillBeginDecelerating(contentScrollView: UIScrollView) {}
    func contentScrollViewDidEndDragging(contentScrollView: UIScrollView, willDecelerate decelerate: Bool) {}
    
}


