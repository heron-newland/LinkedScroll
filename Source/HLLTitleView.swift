//
//  HLLTitleView.swift
//  Demo
//
//  Created by  bochb on 2017/12/21.
//  Copyright © 2017年 com.heron. All rights reserved.
//

import UIKit

open class HLLTitleView: UIView {
    
    /// 文本
   public var label = UILabel()
    //标记视图
   public var markView = UIView()
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override public init(frame: CGRect) {
//        super.init(frame: frame)
//
//    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    
}

extension HLLTitleView {
    
    public convenience init() {
        self.init(frame: .zero)

    }
}

extension HLLTitleView: NSCopying {
    open func copy(with zone: NSZone? = nil) -> Any {
        
        let copy = HLLTitleView()
        copy.label = label
        return copy
    }
}
