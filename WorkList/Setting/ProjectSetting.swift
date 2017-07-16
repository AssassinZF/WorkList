//
//  ProjectSetting.swift
//  WorkList
//
//  Created by Daisy on 2017/7/15.
//  Copyright © 2017年 lzf. All rights reserved.
//

import Foundation
import UIKit

func dbugLog<T>(message: T,
              file: String = #file,
              method: String = #function,
              line: Int = #line)
{
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}

//version
func IS_IOS8() -> Bool { return (UIDevice.current.systemVersion as NSString).doubleValue >= 8.0 }

//screen size
let kScreenHeight = UIScreen.main.bounds.size.height
let kScreenWidth = UIScreen.main.bounds.size.width
