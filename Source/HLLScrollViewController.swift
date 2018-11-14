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
    
   public var titleViewHeight: CGFloat = 40.0{
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
//         scrollContainer.frame = CGRect(x: 0, y: self.navigateBarHeight() + UIApplication.getStatusBarHeight(), width: view.bounds.width, height: view.bounds.height - self.navigateBarHeight() - self.tabBarHeight() - UIApplication.getStatusBarHeight())
       scrollContainer.frame = CGRect(x: safeAreaInset().left, y:  safeAreaInset().top, width: view.bounds.width - safeAreaInset().left - safeAreaInset().right, height: view.bounds.height - safeAreaInset().top - safeAreaInset().bottom)
//        scrollContainer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - self.tabBarHeight())
        
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
       
       
        view.addSubview(scrollContainer)
    }
    
    /// 数据刷新
    open func reloadData(){
        //重新设置数据源
        scrollContainer.reloadData()
//        scrollContainer.scrollTitleView.titles = scrollTitles(for: self.scrollContainer)
//        scrollContainer.scrollContentView.childViewControllers = scrollContentViewControllers(for: self.scrollContainer)
//        scrollContainer.scrollContentView.parentViewController = scrollContentParentViewController(for: self.scrollContainer)
//        //滚动到开始
//        scrollContainer.scroll(to: 0)
    }
    //必需实现的数据源方法, 子类实现
    open func scrollTitles(for scrollView: HLLScrollView?) -> [String] {
        assertionFailure("subClass must implement [scrollContentViewControllers] method")
        return [""]
    }
    
    open func scrollContentViewControllers(for scrollView: HLLScrollView?) -> [UIViewController] {
        assertionFailure("subClass must implement [scrollContentViewControllers] method")
        return [UIViewController()]
    }
    
    open func scrollContentParentViewController(for scrollView: HLLScrollView?) -> UIViewController? {
        assertionFailure("subClass must implement [scrollContentParentViewController] method")
        return UIViewController()
    }
    
    //可选协议实现, 交给子类实现
   open func titleScrollViewDidScroll(titleScrollView: UIScrollView) {}
   open func titleScrollViewWillBeginDragging(titleScrollView: UIScrollView) {}
   open func titleScrollViewDidEndDecelerating(titleScrollView: UIScrollView) {}
   open func titleScrollViewWillBeginDecelerating(titleScrollView: UIScrollView) {}
   open func titleScrollViewDidEndDragging(titleScrollView: UIScrollView, willDecelerate decelerate: Bool) {}
   open func contentScrollViewDidScroll(contentScrollView: UIScrollView) {}
   open func contentScrollViewWillBeginDragging(contentScrollView: UIScrollView) {}
   open func contentScrollViewDidEndDecelerating(contentScrollView: UIScrollView) {}
   open func contentScrollViewWillBeginDecelerating(contentScrollView: UIScrollView) {}
   open func contentScrollViewDidEndDragging(contentScrollView: UIScrollView, willDecelerate decelerate: Bool) {}
    public func loadMoreData(contentScrollView: UIScrollView) {}
}


