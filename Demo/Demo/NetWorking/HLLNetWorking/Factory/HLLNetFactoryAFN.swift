//
//  HLLNetFactoryAFN.swift
//  HLLNetWorking
//
//  Created by  bochb on 2017/12/25.
//  Copyright © 2017年 com.heron. All rights reserved.
//

import UIKit

class HLLNetFactoryAFN: HLLNetFactory {
    override func urlSession() -> HLLSession? {
        return HLLAFNSession()
    }
}
