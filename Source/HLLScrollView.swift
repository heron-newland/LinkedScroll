//
//  HLLScrollView.swift
//  DYZB
//
//  Created by  bochb on 2017/12/15.
//  Copyright © 2017年 com.heron. All rights reserved.
//

import UIKit

public class HLLScrollView: UIView{

    //默认值40.0
    var titleViewHeight: CGFloat = 40.0
    
    weak var dataSource: HLLScrollViewDataSource? {
        didSet{
            
            //scrollTitleView = HLLScrollTitleView(frame:.zero, titles: dataSource?.scrollTitles(for: self))
            scrollTitleView.titles = (dataSource?.scrollTitles(for: self))!
            //设置代理
            scrollTitleView._inner_delegate = self
            
            
            //初始化contentview
            //scrollContentView = HLLScrollContentView(frame:.zero, viewControllers: dataSource?.scrollContentViewControllers(for: self), parentViewController: dataSource?.scrollContentParentViewController(for: self))
            scrollContentView.childViewControllers = (dataSource?.scrollContentViewControllers(for: self))!
            scrollContentView.parentViewController = dataSource?.scrollContentParentViewController(for: self)
            
            //设置代理
            scrollContentView._inner_delegate = self
            //iOS11一下设置这句话
             dataSource?.scrollContentParentViewController(for: self)?.automaticallyAdjustsScrollViewInsets = false
            
        }
    }
    weak var delegate: HLLScrollViewDelegate? {
        didSet{
            scrollTitleView.delegate = delegate
            scrollContentView.delegate = delegate
            
        }
    }
    /// 标题视图
//    var titleView:HLLScrollTitleView {get{
//        return scrollTitleView
//        }}
   lazy var scrollTitleView = HLLScrollTitleView(frame: .zero)
    /// 内容视图
    lazy var scrollContentView = HLLScrollContentView(frame: .zero)
    
//    private lazy var noDataSourceView: UIView = {
//        let noView = UIView(frame: bounds)
//        let label = UILabel(frame: bounds)
//        label.text = "还没有设置数据源, 请设置数据"
//        noView.addSubview(label)
//        return noView;
//    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollTitleView)
        addSubview(scrollContentView)
       
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        assert(dataSource != nil, "还没有设置数据源, 请设置数据")
        scrollTitleView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: titleViewHeight)
        scrollContentView.frame = CGRect(x:0, y: scrollTitleView.frame.maxY, width: scrollTitleView.bounds.width, height: bounds.height - scrollTitleView.frame.maxY)
        //scrollTitleView.frame = CGRect(x: safeAreaInset().left, y: safeAreaInset().top, width: bounds.width - safeAreaInset().left - safeAreaInset().right, height: titleViewHeight)
        //scrollContentView.frame = CGRect(x: safeAreaInset().left, y: scrollTitleView.frame.maxY, width: scrollTitleView.bounds.width, height: bounds.height - scrollTitleView.frame.maxY - safeAreaInset().bottom)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - contentView的代理
extension HLLScrollView: HLLScrollViewControllerDelegate {
    
    //让content随之滚动
    func scrollviewTitleView(titleView: HLLScrollTitleView, didSelect index: Int) {
        scrollContentView.scroll(to: index)
    }
    
    func scrollContentView(contentView: HLLScrollContentView, scroll fromIndex: Int, toIndex: Int, progress: CGFloat) {
        //让titleView的title随之滚动
        scrollTitleView.scroll(from: fromIndex, toIndex: toIndex, progress: progress)
    }
}
//MARK: - pulic function***************************
extension HLLScrollView {
    
    /// 在更多按钮中选中title后滚动到对应的title
    ///
    /// - Parameter index: 选中title的下标
   open func scroll(to index: Int) {
        scrollContentView.scroll(to: index)
        scrollTitleView.scroll(to: index)
    }
    
    
}
