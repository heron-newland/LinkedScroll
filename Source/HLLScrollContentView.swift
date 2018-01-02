//
//  HLLScrollContentView.swift
//  DYZB
//
//  Created by  bochb on 2017/12/13.
//  Copyright © 2017年 com.heron. All rights reserved.
//



import UIKit

public class HLLScrollContentView: UIView {
    
    /// 对外公布的代理方法
    weak var delegate: HLLScrollViewDelegate?

    /// 是否支持左右滑动切换标签
   public var isPanToSwitchEnable: Bool = true {
        didSet{
         
            self.collectionView.isScrollEnabled = isPanToSwitchEnable
            
        }
    }
    
    
   private let itemReuserId = "itemReuserId"
    var parentViewController: UIViewController?{
        didSet{
            for vc in childViewControllers {
                if parentViewController != nil {
                    parentViewController!.addChildViewController(vc)
                }
            }
        }
    }
     var childViewControllers = [UIViewController](){
        didSet{
                assert(childViewControllers.count != 0, "viewControllers数组不能为空")
                configureUI()
    }
    }
    /// 内部使用代理, 处理上下联动逻辑使用的, 如果重写该代理一定要调用super
    weak var _inner_delegate: HLLScrollViewControllerDelegate?
    
    /// 开始滑动前的偏移量, 判断左滑还是又滑
    private var beginningOffsetX: CGFloat = 0
    
    /// 当前选中的item的下标
    private var currentIndex: Int = 0
    
    /// 标记是标题被点击引起的滚动还是手势滚动
    private var isScrollTriggerByTap = false

    private var layout = UICollectionViewFlowLayout()
    
    private lazy var collectionView: UICollectionView = { [unowned self] in
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
       
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.scrollsToTop = false
        collection.isPagingEnabled = true
        collection.dataSource = self
        collection.delegate = self
        collection.bounces = false
       //collection.isPrefetchingEnabled = false
        collection.showsHorizontalScrollIndicator = false
        
        return collection
    }()
    
    
    

    
    @objc func rotate(){
        isScrollTriggerByTap = true
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        //设置item大小
        collectionView.frame = bounds
        layout.itemSize = collectionView.bounds.size
        collectionView.selectItem(at: IndexPath(item: currentIndex, section: 0), animated: false, scrollPosition: .centeredHorizontally)
        //collectionView.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         NotificationCenter.default.addObserver(self, selector: #selector(rotate), name: NSNotification.Name.UIApplicationWillChangeStatusBarFrame, object: nil)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}

extension HLLScrollContentView {
   
    convenience init(frame: CGRect, viewControllers: [UIViewController]?, parentViewController: UIViewController?) {
        self.init(frame: frame)
        if viewControllers?.count != 0 {
            
            
            //assert(viewControllers?.count != 0, "viewControllers数组不能为空")
            
            for vc in viewControllers! {
                if parentViewController != nil {
                    parentViewController!.addChildViewController(vc)
                }
            }
            self.childViewControllers = viewControllers!
            //backgroundColor = UIColor.randomColor()
            configureUI()
        }
    }
    
    
}
extension HLLScrollContentView {
    private func configureUI() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: itemReuserId)
        addSubview(collectionView)
        
    }
}


// MARK: - collection 数据源和代理
extension HLLScrollContentView: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childViewControllers.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemReuserId, for: indexPath)
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        cell.backgroundColor = UIColor.white

        let content = childViewControllers[indexPath.row].view!
        //content?.frame = cell.bounds
        content.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(content)
        //使用约束解决布局问题最好, 使用frame由于是添加的vc的view, 旋转之后布局会出现异常
        let top = NSLayoutConstraint(item: content, attribute: .top, relatedBy: .equal, toItem: cell.contentView, attribute: .top, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: content, attribute: .leading, relatedBy: .equal, toItem: cell.contentView, attribute: .leading, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: content, attribute: .bottom, relatedBy: .equal, toItem: cell.contentView, attribute: .bottom, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: content, attribute: .trailing, relatedBy: .equal, toItem: cell.contentView, attribute: .trailing, multiplier: 1, constant: 0)
        cell.contentView.addConstraints([top, left, bottom, right ])
        return cell
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrollTriggerByTap = false
        beginningOffsetX = scrollView.contentOffset.x
        
        delegate?.contentScrollViewWillBeginDragging?(contentScrollView: scrollView)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if isScrollTriggerByTap {
            //currentIndex = Int(scrollView.contentOffset.x / collectionView.bounds.width)
            return
        }
        
        let offSetX: CGFloat = scrollView.contentOffset.x
        
        var fromIndex: Int = 0
        var toIndex: Int = 0
        let scrollDelta = scrollView.bounds.width
        var progress: CGFloat = 0
        if   offSetX >= beginningOffsetX {

            progress = offSetX/scrollDelta - floor(offSetX/scrollDelta)
            fromIndex = Int(offSetX/scrollDelta)
            toIndex = fromIndex + 1
            
            if toIndex >= childViewControllers.count {
                toIndex = childViewControllers.count - 1
            }
            if offSetX - beginningOffsetX == scrollDelta{
                progress = 1.0
                toIndex = fromIndex
            }
            
        }
         if   offSetX <= beginningOffsetX {
             progress = 1 - (offSetX/scrollDelta - floor(offSetX/scrollDelta))
            //左滑, offset-0.1防止下标在左滑停止的时候都+1

            toIndex = Int(offSetX/scrollDelta)
            fromIndex = toIndex + 1
            if fromIndex >= childViewControllers.count {
                fromIndex = childViewControllers.count - 1
            }
            if beginningOffsetX - offSetX == scrollDelta {
                fromIndex = toIndex
            }
           
        }

        
        _inner_delegate?.scrollContentView(contentView: self, scroll: fromIndex, toIndex: toIndex, progress: progress)

      delegate?.contentScrollViewDidScroll?(contentScrollView: scrollView)
        
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       currentIndex = Int(scrollView.contentOffset.x / collectionView.bounds.width)
        delegate?.contentScrollViewDidEndDecelerating?(contentScrollView: scrollView)
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.contentScrollViewDidEndDragging?(contentScrollView: scrollView, willDecelerate: decelerate)
    }
  
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.contentScrollViewWillBeginDecelerating?(contentScrollView: scrollView)
    }
}





// MARK: - 对外的方法
extension HLLScrollContentView {
    
    /// 根据条目滚动内容
    ///
    /// - Parameter index: 滚动到的index
   open func scroll(to index: Int) {
        isScrollTriggerByTap = true
        currentIndex = index
        collectionView.setContentOffset(CGPoint(x: CGFloat(index) * bounds.width, y: 0), animated: false)
    }
    
    
}
