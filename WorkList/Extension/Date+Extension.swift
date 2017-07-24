//
//  Date+Extension.swift
//  WorkList
//
//  Created by zhanfeng on 2017/7/24.
//  Copyright © 2017年 lzf. All rights reserved.
//

import Foundation
import UIKit

extension Date{
    static func stringWithCurrentDate() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYY-MM-dd HH:mm"
        return dateFormat.string(from: Date())
    }
}
