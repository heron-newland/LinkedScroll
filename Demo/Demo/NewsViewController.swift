//
//  NewsViewController.swift
//  DYZB
//
//  Created by  bochb on 2017/12/15.
//  Copyright © 2017年 com.heron. All rights reserved.
//

import UIKit
//这样定义的是常量, 在屏幕旋转的时候UIScreen的值变化, 但是kScreenWidth不会变化, 到时布局错误
//let kScreenWidth = UIScreen.main.bounds.width
class NewsViewController: UIViewController {
    
    let margin: CGFloat = 10
    let itemId = "itemId"
    let bigItemId = "bigItemId"
    let sectionHeaderId = "sectionHeaderId"
    private lazy var layout = UICollectionViewFlowLayout()
    private lazy var collectionView: UICollectionView = { [unowned self] in
        let collection = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        
        collection.backgroundColor = UIColor.white
        //大小item分别注册, 提高效率, 防止重用出现问题
        //注册小item
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: itemId)
        //注册大item
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: bigItemId)
        collection.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: sectionHeaderId)
        
        return collection
        }()
    
    private var backButton: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        btn.setTitle("back", for: .normal)
        btn.backgroundColor = UIColor.randomColor()
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.addSubview(collectionView)
        view.addSubview(backButton)
        view.backgroundColor = UIColor.white
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.frame = CGRect(x: view.bounds.width - 70, y: 0, width: 60, height: 44)
        
        collectionView.frame = view.bounds
        let itemWidth = (collectionView.bounds.width - safeAreaInset().left - safeAreaInset().right - margin * 3.0) / 2.0
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 3 / 4)
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: 44)
        layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin)
        collectionView.reloadData()
    }
    
    
    @objc func backAction(){
        dismiss(animated: true, completion: nil)
    }
}


extension NewsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 || section == 3 {
            return 6
        }
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        if indexPath.section == 1 || indexPath.section == 3 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemId, for: indexPath)
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: bigItemId, for: indexPath)
        }
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        let label = UILabel(frame: cell.bounds)
        cell.contentView.addSubview(label)
        label.textAlignment = .center
        label.text = "第\(indexPath.section)区\(indexPath.item)个"
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: sectionHeaderId, for: indexPath)
        for subView in header.subviews {
            subView.removeFromSuperview()
        }
        //大背景设为透明, 在里面添加小容器视图, 应为collectionview
        header.backgroundColor = UIColor.clear
        let content = UIView(frame: CGRect(x: margin, y: 0, width: header.bounds.width - margin * 2, height: header.bounds.height))
        content.backgroundColor = UIColor.white
        let label = UILabel(frame: content.bounds)
        content.addSubview(label)
        label.textAlignment = .center
        label.text = "第\(indexPath.section)个标题"
        header.addSubview(content)
        return header
    }
    
    /// 改变item大小的代理方法
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        if indexPath.section == 1 || indexPath.section == 3 {
            return CGSize(width: (collectionView.bounds.width - margin * 3.0) / 2.0, height: (collectionView.bounds.width - margin * 3.0) / 2.0 * 4.0 / 3.0)
        }
        return layout.itemSize
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //由于次控制器是将其view添加到父控制器中, 所有该控制器不处于当前导航控制器栈, 所以push的时候要先获取导航控制器
        let tab = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController
        let nav = tab?.selectedViewController as? UINavigationController
        let backItem = UIBarButtonItem()
        backItem.title = "back"
        nav?.viewControllers.last?.navigationItem.backBarButtonItem = backItem
        
        //点击跳转, 下面分别使用push, present, push带tabbar, present带tabbar, 来测试兼容性, 包括屏幕旋转
        if indexPath.section == 0 {//push
           let toVC = ViewController()
//            let backItem = UIBarButtonItem()
//           backItem.title = "back"
//            toVC.navigationItem.backBarButtonItem = backItem
            nav?.pushViewController(toVC, animated: true)
        }else if indexPath.section == 1{//present
            present(ViewController(), animated: true, completion: nil)
        }else if indexPath.section == 2{//tabbar
            let tabbarVC = UITabBarController()
            let first = ViewController()
            let sec = ViewController()
            tabbarVC.viewControllers = [first, sec]
            first.tabBarItem.title = "News"
            sec.tabBarItem.title = "Nothing"
            sec.view.backgroundColor = UIColor.white
            nav?.pushViewController(tabbarVC, animated: true)
        }else{
            let tabbarVC = UITabBarController()
            let first = ViewController()
            let sec = ViewController()
            tabbarVC.viewControllers = [first, sec]
            first.tabBarItem.title = "News"
            sec.tabBarItem.title = "Nothing"
            sec.view.backgroundColor = UIColor.white
            present(tabbarVC, animated: true, completion: nil)
        }
    }
    
}
