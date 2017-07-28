//
//  SingleOnce.swift
//  WorkList
//
//  Created by zhanfeng on 2017/7/28.
//  Copyright © 2017年 lzf. All rights reserved.
//

import Foundation

class SingleOnce {
    // 单例
    static let shared = SingleOnce.init()
    private init(){}
    
    var isFocusModel = false //是否为专注模式
    

}
