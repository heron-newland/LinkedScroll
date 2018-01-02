//
//  HLLViewController.swift
//  Demo
//
//  Created by  bochb on 2017/12/21.
//  Copyright © 2017年 com.heron. All rights reserved.
//

import UIKit

class HLLViewController: HLLScrollViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func scrollTitles(for scrollView: HLLScrollView?) -> [String] {
        return ["新闻房产", "体育", "房产财经", "房产", "动漫房产", "动漫","新闻房产", "体育",]
    }
    
    /// 内容数据源
    ///
    /// - Parameter scrollView:
    /// - Returns: 控制器数组, 用于显示内容
    override func scrollContentViewControllers(for scrollView: HLLScrollView?) -> [UIViewController] {
        var controllers = [UIViewController]()
        //这里简单用for循环创建控制器, 具体控制器根据实际情况创建
        for _ in 0 ..< 8 {
            controllers.append(NewsViewController())
        }
        return controllers
    }
    
    /// 内容控制器的父控制器, 用来添加自控制器,可以不实现, 默认为nil
    override func scrollContentParentViewController(for scrollView: HLLScrollView?) -> UIViewController? {
        return self;
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
