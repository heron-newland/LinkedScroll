//
//  HLLScrollTitleView.swift
//  DYZB
//
//  Created by  bochb on 2017/12/13.
//  Copyright © 2017年 com.heron. All rights reserved.
//






import UIKit

public class HLLScrollTitleView: UIView {
    
    /// 每个标题View
   public var titleView: [HLLTitleView]? {
        didSet{
            congfigureTitle()
        }
    }
    
    /// title的标记是否在点击之后消失
   public var isMarkHiddenByTap = true
    
    /// 带颜色的指示线
   public var lineView = UIView()
    
   public var backgroudLine = UIView()
    /// 指示线的高度
   public var lineHeight: CGFloat = 2.0
    /// titleLabel 的间距, 可以随便改
   public var margin: CGFloat = 10.0
   public var backgroundLineHeight: CGFloat = 1.0
    /// 文字颜色
   public var normalTextColor: UIColor = UIColor.darkGray{
        didSet{
            for (index, titleV) in titleLabels.enumerated() {
                if index != 0 {
                    titleV.label.textColor = normalTextColor
                }
            }
        }
    }
    
    /// 高亮文字颜色
   public var highlightTextColor: UIColor = UIColor.orange {
        didSet{
            titleLabels[0].label.textColor = highlightTextColor
            lineView.backgroundColor = highlightTextColor
        }
    }
    
    /// 字体和大小
   public var textFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .black) {
        didSet{
            for titleV in titleLabels {
                titleV.label.font = textFont
            }
        }
    }
    
    /// 指示线是否隐藏, 默认不隐藏
   public var isIndicatorLineHidden: Bool = false {
        didSet{
            self.lineView.isHidden = isIndicatorLineHidden
        }
    }
    
    /// 当前选中的文字变大的比例, 设置为0.0不进行缩放, 默认为0.0
   public var textScaleRate: CGFloat = 0.0 {
        didSet{
            //第一个label设置其transform
            titleLabels[0].transform = CGAffineTransform(scaleX: 1 + self.textScaleRate, y:  1 + self.textScaleRate)
            changeLabelWidth()
        }
    }
    
    /// 对外公布的代理方法
   public weak var delegate: HLLScrollViewDelegate?
    
    
    /// 标题数组
   public var titles:[String] = []{
        didSet{
            configureUI()
        }
    }
    
   public var rightView: UIView? {
        didSet{
            //添加右视图
            guard let right = rightView else { return  }
            addSubview(right)
            
        }
    }
    
    /// scroll容器
    private lazy var scrollContainer: UIScrollView = {
        let scroll = UIScrollView(frame: bounds)
        scroll.delegate = self
        scroll.showsHorizontalScrollIndicator = false
        scroll.bounces = false
        return scroll
    }()
    
    /// 标题label数组
    var titleLabels = [HLLTitleView]()
    
    /// 当前选中的label的下标
    private var currentIndex: Int = 0
    
    
    private var isScrollTriggerByTap = false
    
    
    /// 内部使用代理, 处理上下联动逻辑使用的, 如果重写该代理一定要调用super
    weak var _inner_delegate: HLLScrollViewControllerDelegate?
    
    
    /// 上次被选中的label的下标
    //private var lastSelectedLabelIndex: Int = 0
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension HLLScrollTitleView{
    convenience public init(frame: CGRect, titles: [String]?) {
        self.init(frame: frame)
        //assert(titles != nil, "titles数组不能为空")
        if titles != nil {
            self.titles = titles!
            //backgroundColor = UIColor.randomColor()
            configureUI()
        }
    }
}
// MARK: - configureUI
extension HLLScrollTitleView {
    private func configureUI() {
        
        addSubview(scrollContainer)
        congfigureTitle()
        configureLine()
    }
    
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        autoresizingMask = .flexibleHeight
        
        //设置scrollContainer的frame
        if rightView != nil {
            scrollContainer.frame =  CGRect(x: 0, y: frame.origin.y, width: frame.size.width - rightView!.bounds.width, height: frame.size.height)
            rightView!.frame = CGRect(x: frame.size.width - rightView!.bounds.width, y: frame.origin.y, width: rightView!.bounds.width, height: frame.size.height)
        }else{
            scrollContainer.frame = frame
        }
        let currentLabel = titleLabels[currentIndex]
        //设置lineView的frame
        lineView.bounds = CGRect(x: 0, y: 0, width: currentLabel.bounds.width, height: lineHeight)
        lineView.center = CGPoint(x: currentLabel.center.x, y: bounds.height - lineHeight * 0.5)
        //设置backgroudLine的frame
        backgroudLine.frame = CGRect(x: 0, y: bounds.height - backgroundLineHeight, width: bounds.width, height: backgroundLineHeight)
        changeLabelWidth()
        setScrollContainerOffset(by: currentIndex)
        
    }
    
    
    private func congfigureTitle() {
        for subView in titleLabels {
            subView.removeFromSuperview()
        }
        titleLabels.removeAll()
        //添加label
        for (index, title) in titles.enumerated() {
            var titleV: HLLTitleView
            if titleView == nil {
                titleV = HLLTitleView()
                
            }else{
                
                titleV = titleView![index]
            }
            scrollContainer.addSubview(titleV)
            titleV.label.font = textFont
            titleV.label.textColor = normalTextColor
            titleV.label.textAlignment = .center
            //设置label的属性, 有特殊要求可以自定义label
            titleV.label.text = title
            
            titleV.tag = index
            titleV.isUserInteractionEnabled = true
            titleV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTapped(sender:))))
            titleLabels.append(titleV)
            
            if index == 0 {
                //默认选中第一个
                titleV.label.textColor = highlightTextColor
            }
        }
        
        
    }
    
    /// label被点击
    @objc func labelTapped(sender: UITapGestureRecognizer){
        
        let currentSelectedLabel = sender.view as! HLLTitleView

        hiddenMark(at: currentSelectedLabel.tag)
        scroll(to: currentSelectedLabel.tag)
        
    }
    private func hiddenMark(at index: Int){
        if isMarkHiddenByTap {
            UIView.animate(withDuration: 0.5, animations: {
                self.titleLabels[index].markView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: { (_) in
                UIView.animate(withDuration: 0.5, animations: {
                    
                    self.titleLabels[index].markView.alpha = 0
                })
            })
            
        }
    }
    
    /// 设置scrollContainer的偏移量, 滑动和点击都调用
    /// 让选中的title居中显示,针对scrollContainer居中
    /// - Parameter index: 起始labe的index
    private func setScrollContainerOffset(by index: Int) {
        if scrollContainer.contentSize.width <= bounds.width {
            return
        }
        var scrollX: CGFloat = 0
        if titleLabels[index].frame.origin.x + titleLabels[index].bounds.width * 0.5 + scrollContainer.bounds.width * 0.5 < scrollContainer.contentSize.width {
            if titleLabels[index].frame.origin.x > scrollContainer.bounds.width * 0.5 {
                scrollX = titleLabels[index].frame.origin.x - scrollContainer.bounds.width * 0.5 + titleLabels[index].bounds.width * 0.5
            }else {
                scrollX = 0.0
            }
        }else{
            scrollX = scrollContainer.contentSize.width - scrollContainer.bounds.width
            
        }
        scrollContainer.setContentOffset(CGPoint(x: scrollX, y: 0), animated: true)
        
    }
    
    private func configureLine() {
        
        lineView.backgroundColor = highlightTextColor
        
        backgroudLine.backgroundColor = UIColor(white: 0.9, alpha: 1)
        addSubview(backgroudLine)
        scrollContainer.insertSubview(lineView, at: 0)
        //scrollContainer.addSubview(lineView)
    }
    
    
    /// 设置字体缩放系数后重新计算label的frame
    private func changeLabelWidth() {
        var originMargin = margin
        //所有label的和margin的总宽度
        var totalWidth: CGFloat = 0
        let labelY: CGFloat = 0.0
        var labelWidth: CGFloat = 0
        let labelHeight = bounds.height
        var titleStr: NSString?
        var titleSize: CGSize = .zero
        var labelX: CGFloat = 0.0
        //条目宽度+margin宽度小于当前view的宽度, 将多余间距均分给每个条目, 让其撑满view的宽度
        var tempTotalWidth: CGFloat = 0
        let newFont = UIFont.systemFont(ofSize: textFont.pointSize * (1 + textScaleRate))
        for title in titles {
            //计算title文字宽度
            titleStr = title as NSString
            
            
            titleSize = (titleStr?.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: textFont.lineHeight), options: .usesFontLeading, attributes: [.font : newFont], context: nil).size)!
            tempTotalWidth += (titleSize.width + originMargin)
        }
        
        if tempTotalWidth <= bounds.width {//个数不足以平铺整个bounds.width
            originMargin += (bounds.width - tempTotalWidth) / CGFloat(titles.count)
        }
        
        for (index, title) in titles.enumerated() {
            //计算title文字宽度
            titleStr = title as NSString
            titleSize = (titleStr?.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: textFont.lineHeight), options: .usesFontLeading, attributes: [.font : newFont], context: nil).size)!
            
            labelWidth = titleSize.width + originMargin
            labelX = totalWidth
            titleLabels[index].frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
            totalWidth += labelWidth
        }
        scrollContainer.contentSize = CGSize(width: totalWidth, height: bounds.height)
        print(scrollContainer.contentSize.height)
    }
}

extension HLLScrollTitleView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.titleScrollViewDidScroll?(titleScrollView: scrollView)
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.titleScrollViewDidEndDecelerating?(titleScrollView: scrollView)
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.titleScrollViewDidEndDragging?(titleScrollView: scrollView, willDecelerate: decelerate)
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.titleScrollViewWillBeginDragging?(titleScrollView: scrollView)
    }
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        delegate?.titleScrollViewWillBeginDecelerating?(titleScrollView: scrollView)
    }
    
}
// MARK: - public func
extension HLLScrollTitleView {
    
    /// 滚动标题
    ///
    /// - Parameters:
    ///   - index: 起始下标
    ///   - toIndex: 目的下标
    ///   - progress: 进度
   open func scroll(from index: Int, toIndex: Int, progress: CGFloat) {
        
        if isScrollTriggerByTap {//如果是点击title的动作不掉用此方法
            isScrollTriggerByTap = false
            return
        }
        //print("\(index)==\(toIndex)")
        let fromLabel = titleLabels[index]
        let toLabel = titleLabels[toIndex]
        //label颜色改变
        
        let toColorR = (highlightTextColor.getRGB().red - normalTextColor.getRGB().red) * progress + normalTextColor.getRGB().red
        let toColorG = (highlightTextColor.getRGB().green - normalTextColor.getRGB().green) * progress + normalTextColor.getRGB().green
        let toColorB = (highlightTextColor.getRGB().blue - normalTextColor.getRGB().blue) * progress + normalTextColor.getRGB().blue
        
        let fromColorR =  highlightTextColor.getRGB().red - (highlightTextColor.getRGB().red - normalTextColor.getRGB().red) * progress
        let fromColorG =  highlightTextColor.getRGB().green - (highlightTextColor.getRGB().green - normalTextColor.getRGB().green) * progress
        let fromColorB =  highlightTextColor.getRGB().blue - (highlightTextColor.getRGB().blue - normalTextColor.getRGB().blue) * progress
        fromLabel.label.textColor = UIColor(red: fromColorR, green: fromColorG, blue: fromColorB, alpha: 1)
        toLabel.label.textColor = UIColor(red: toColorR, green: toColorG, blue: toColorB, alpha: 1)
        
        //移动线条的位置
        //       let lineX = (toLabel.frame.origin.x - fromLabel.frame.origin.x) * progress + titleLabels[index].frame.origin.x
        let lineWidthDelta = (toLabel.bounds.width - fromLabel.bounds.width) * progress + titleLabels[index].bounds.width
        //
        //        lineView.frame = CGRect(x: lineX, y: lineView.frame.origin.y, width: lineWidthDelta, height: lineView.bounds.height)
        
        
        self.lineView.bounds = CGRect(x: 0, y: 0, width: lineWidthDelta, height: lineView.bounds.height)
        
        self.lineView.center = CGPoint(x: (toLabel.center.x - fromLabel.center.x) * progress + titleLabels[index].center.x, y: self.lineView.frame.origin.y + lineView.bounds.height * 0.5)
        
        //当前选中label变大
        toLabel.transform = CGAffineTransform(scaleX: 1 + progress * textScaleRate, y:  1 + progress * textScaleRate)
        //        fromLabel.transform = CGAffineTransform(scaleX: 1 - progress * textScaleRate, y:  1 - progress * textScaleRate)
        if progress != 0.0 && progress != 1.0 {
            UIView.animate(withDuration: 0.3, animations: {
                fromLabel.transform = .identity
            })
        }

        //记录当前选中的label
        //处理连续滑动造成index混乱
        if progress == 0.0 {
            
            currentIndex = index
            titleLabels[currentIndex].label.textColor = highlightTextColor
            hiddenMark(at: currentIndex)
            
        }
        if progress == 1.0 {
            currentIndex = toIndex
            hiddenMark(at: currentIndex)
        }
        setScrollContainerOffset(by: currentIndex)
    }
    
    /// 滚动到对应的位置
    ///
   open func scroll(to index: Int) {
        let currentSelectedLabel = titleLabels[index]
        if currentIndex == index {
            return
        }
        let lastLabel = titleLabels[currentIndex]
        UIView.animate(withDuration: 0.5) {
            //线条移动
            self.lineView.bounds = CGRect(x: 0, y: 0, width: currentSelectedLabel.bounds.width, height: self.lineHeight)
            self.lineView.center = CGPoint(x: currentSelectedLabel.center.x, y: self.lineView.frame.origin.y + self.lineHeight * 0.5)
            
            currentSelectedLabel.label.textColor = self.highlightTextColor
            lastLabel.label.textColor = self.normalTextColor
            //当前选中label变大
            currentSelectedLabel.transform = CGAffineTransform(scaleX: 1 + self.textScaleRate, y:  1 + self.textScaleRate)
            lastLabel.transform = .identity
        }
        
        //保存当前的下标, 为下次点击时取上一个被选中的label
        currentIndex = currentSelectedLabel.tag
        
        isScrollTriggerByTap = true
        
        setScrollContainerOffset(by: currentIndex)
        //调用代理做搞事情
        _inner_delegate?.scrollviewTitleView(titleView: self, didSelect: currentIndex)
        
        delegate?.titleScrollView?(titleScrollView: scrollContainer, titleLabel: currentSelectedLabel, tappedIndex: currentIndex)
    }
   
    
}
