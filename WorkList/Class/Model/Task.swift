//
//  Task.swift
//  WorkList
//
//  Created by zhanfeng on 2017/7/20.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

enum PriorityType:Int {
    case PriorityTypeLow = 0
    case PriorityTypeMidding
    case PriorityTypeHeight
    
    static func getTaskPriorityWithendTime(endTime:Date) -> PriorityType {
        let currenTimeSecond = Date().timeIntervalSince1970
        let endTimeSecond = endTime.timeIntervalSince1970
        if currenTimeSecond >= endTimeSecond {
            return .PriorityTypeLow
        }
        let second = endTimeSecond - currenTimeSecond
        if second <= 60*30 {
            return .PriorityTypeHeight
        }else if second <= 2*60*60 {
            return .PriorityTypeMidding
        }else{
            return .PriorityTypeLow
        }
    }
    
    func colorWithPriority() -> UIColor {
        switch self {
        case .PriorityTypeLow:
            return UIColor.flatGreen
        case .PriorityTypeMidding:
            return UIColor.flatYellow
        case .PriorityTypeHeight:
            return UIColor.flatRed
        }
    }
}

class Task: Object {
    
    dynamic let creatTime:Date = Date()
    dynamic var modifityTime:Date = Date()
    dynamic var textInfo:String = ""
    dynamic var endTime:Date?
    dynamic var taskPriorty = PriorityType.PriorityTypeLow.rawValue
    dynamic var isFinish = false //是否完成
    dynamic var isOverdue = false //是否逾期
    
    var setEndTime:Date{
        set{
            endTime = newValue
            taskPriorty = PriorityType.getTaskPriorityWithendTime(endTime: endTime!).rawValue
        }
        get{
            return Date()
        }
    }
    
    func contentHeight(task:Task) -> CGFloat {
        let maxHeight = UILabel.getLabHeight(labelStr: task.textInfo as NSString, font: textFont, width: kScreenWidth - leftSpace*2)
        var height:CGFloat = max(maxHeight, textMinHeight)
        if task.endTime != nil {
            height += endTimeHeight
        }
        height += topSpace*2
        return height

    }
}

