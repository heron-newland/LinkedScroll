//
//  HLLTitleView.swift
//  Demo
//
//  Created by  bochb on 2017/12/21.
//  Copyright © 2017年 com.heron. All rights reserved.
//

import UIKit

class HLLTitleView: UIView {
    
    /// 文本
    var label = UILabel()
    //标记视图
    var markView = UIView()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    
}

extension HLLTitleView {
    
    convenience init() {
        self.init(frame: .zero)
        addSubview(label)
    }
}

extension HLLTitleView: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        
        let copy = HLLTitleView()
        copy.label = label
        return copy
    }
}
