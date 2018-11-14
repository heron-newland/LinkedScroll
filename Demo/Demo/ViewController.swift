//
//  ViewController.swift
//  Demo
//
//  Created by  bochb on 2018/1/2.
//  Copyright © 2018年 com.heron. All rights reserved.
//

import UIKit

class ViewController : UIViewController, HLLScrollViewDataSource, HLLScrollViewDelegate {
    //假定数据源
    var data = ["新闻","大家都在看", "直播", "体育", "财经", "房产", "动漫", "猜你感兴趣","大家都在看", "直播"]
    var titles = [String]()
    
    /// 懒加载一个HLLScrollView, 并设置相关属性
    private lazy var scrollView: HLLScrollView = {
        let sView = HLLScrollView()


        //title的高度
        //sView.titleViewHeight = 100.0
        
        //数据源
        sView.dataSource = self
        
        //代理
        sView.delegate = self
        
        //titleView的高度
        //文字高亮颜色, 指示线的颜色默认和高亮文字颜色一致也可以通过scrollTitleView.lineView.backgroundColor属性自行修改
        //sView.scrollTitleView.highlightTextColor = UIColor.red
        
        //文字普通颜色
        //sView.scrollTitleView.normalTextColor = UIColor.gray
        
        //title绘制圆角
        //        sView.scrollTitleView.lineView.layer.cornerRadius = 16
        
        //指示线的高度
        //        sView.scrollTitleView.lineHeight = 44
        
        //指示线背景颜色
        //        sView.scrollTitleView.lineView.backgroundColor = UIColor.blue
        
        //当前选中label放大的增量, 如果设为0.0则不缩放, 默认值为0.0, 不要设置太大, 值太大由于高度不够文字会显示不全
        sView.scrollTitleView.textScaleRate = 0.2
        
        //是否隐藏指示线条
        //sView.scrollTitleView.isIndicatorLineHidden = true
        
        //title的间隔
        sView.scrollTitleView.margin = 30
        //title字体
        sView.scrollTitleView.textFont = UIFont.systemFont(ofSize: 17)
        
        //title背景颜色
        //sView.backgroundColor = UIColor.white
        
        //是否允许左右滑动内容来切换标题标签, 默认为true
        //        sView.scrollContentView.isPanToSwitchEnable = false
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        btn.setImage(#imageLiteral(resourceName: "增加-4"), for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        //设置右边的更多按钮
        sView.scrollTitleView.rightView = btn
        
        //markView是否在点击或者滚动到当前title时候隐藏
        // sView.scrollTitleView.isMarkHiddenByTap = false
        
        return sView
    }()
    
    
    
    @objc func btnClick() {
        scrollView.scroll(to: 3)
    }
    
//    @IBAction func updateData(_ sender: Any) {
//        titles.removeFirst()
//    }
    
    //更新数据的方法
    @IBAction func reload(_ sender: Any) {
        let i = arc4random_uniform(UInt32(data.count))
        if i == 0 {
            return
        }
        var refreshedTitles = [String]()
        for j in 0..<Int(i) {
            refreshedTitles.append(data[j])
        }
        titles = refreshedTitles
        scrollView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titles = data
        //添加HLLScrollView对象到控制器view中
        //self.automaticallyAdjustsScrollViewInsets = false
        view.autoresizingMask = [.flexibleTopMargin, .flexibleHeight]
        view.addSubview(scrollView)
        view.backgroundColor = UIColor.white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //设置HLLScrollView对象的frame
        //方式一: 自己计算, 导航栏, tabbar, statusBar的高度
        //scrollView.frame = CGRect(x: 0, y: self.navigateBarHeight() + UIApplication.getStatusBarHeight(), width: view.bounds.width, height: view.bounds.height - self.navigateBarHeight() - self.tabBarHeight() - UIApplication.getStatusBarHeight())
        //方式二, 利用安全区域计算
        scrollView.frame = CGRect(x: safeAreaInset().left, y:  safeAreaInset().top, width: view.bounds.width - safeAreaInset().left - safeAreaInset().right, height: view.bounds.height - safeAreaInset().top - safeAreaInset().bottom)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//MARK: - delegate
    func titleScrollView(titleScrollView: UIScrollView, titleLabel: HLLTitleView, tappedIndex: Int) {
        
    }
    func titleScrollView(titleScrollView: UIScrollView, titleLabel: UILabel, tappedIndex: Int) {
        //        print(tappedIndex)
        //        print(titleLabel.text)
        //        print(titleScrollView.contentOffset.x)
    }
    func titleScrollViewDidScroll(titleScrollView: UIScrollView) {
        //        print(titleScrollView.contentOffset.x)
    }
    func contentScrollViewDidScroll(contentScrollView: UIScrollView) {
        //        print(contentScrollView.contentOffset.x)
    }
    
    //MARK: - dataSource
    
    /// 标题数组:必须实现
    ///
    /// - Parameter scrollView:
    /// - Returns:
    func scrollTitles(for scrollView: HLLScrollView?) -> [String] {
        return titles
    }
    
    /// 控制器数组:必须实现
    /// 标题数组和控制器数组一一对应
    func scrollContentViewControllers(for scrollView: HLLScrollView?) -> [UIViewController] {
        var controllers = [UIViewController]()
        for _ in 0 ..< titles.count {
            controllers.append(NewsViewController())
        }
        return controllers
    }
    
    ///HLLScrollView的父控制器:必须实现
    func scrollContentParentViewController(for scrollView: HLLScrollView?) -> UIViewController? {
        return self;
    }
    
    /// 自定义标题组件数组, 可选:实现
    func scrollTitleViews(for scrollView: HLLScrollView?) -> [HLLTitleView]? {
        var ts = [TitleView]()
        //根据标题初始化titleView中的每一个title视图, 下面简单的使用for循环创建,可以根据实际需求创建
        //TitleView 是每个title的自定义视图, 继承自HLLTitleView
        for (index, _) in titles.enumerated() {
            let tView = TitleView()
            //是否隐藏mark, 实际应用时如果服务器数据有更新可以让mark显示
            tView.isMarkHidden = index % 2 == 0
            ts.append(tView as HLLTitleView as! TitleView)
        }
        return ts
    }
    
    
}

