//
//  TitleView.swift
//  Demo
//
//  Created by  bochb on 2017/12/21.
//  Copyright © 2017年 com.heron. All rights reserved.
//

import UIKit

class TitleView: HLLTitleView {
    
    lazy var right:UIView = {
        let r = UIView()
        r.layer.cornerRadius = 5
        r.isHidden = true
        r.backgroundColor = UIColor.red
        return r
    }()
    
    var isMarkHidden = true {
        didSet{
            markView.isHidden = isMarkHidden
        }
    }
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        markView = right
        addSubview(markView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label.bounds = CGRect(x: 0, y: 0, width: bounds.width * 0.8, height: bounds.height * 0.8)
        //不要使用, 这个center是相对于父视图中心坐标,我们要找的点是相对于本视图的中心点坐标
       // label.center = center
        label.center = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
        markView.frame = CGRect(x: label.frame.maxX - 10, y: label.frame.minY, width: 10, height: 10)
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
       let copy = super.copy(with: zone) as! HLLTitleView
        
        return copy
    }
}
