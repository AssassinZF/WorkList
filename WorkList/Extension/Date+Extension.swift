//
//  Date+Extension.swift
//  WorkList
//
//  Created by zhanfeng on 2017/7/24.
//  Copyright © 2017年 lzf. All rights reserved.
//

import Foundation
import UIKit

enum DateFormatType:String {
    case Y = "YYYY"
    case YM = "YYYY-MM"
    case YMD = "YYY-MM-dd"
    case YMdHm = "YYYY-MM-dd HH:mm"
}

extension Date{
    static func stringWithCurrentDate() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYY-MM-dd HH:mm"
        return dateFormat.string(from: Date())
    }
    
    func stringWithDate() ->String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYY-MM-dd HH:mm"
        return dateFormat.string(from: self)
    }
    
    func stringWithFormat(Format:DateFormatType) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = Format.rawValue
        return dateFormat.string(from: self)

    }
}
