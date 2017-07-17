//
//  Task.swift
//  WorkList
//
//  Created by Daisy on 2017/7/15.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit
import RealmSwift

//任务等级
enum TaskRand:Int{
    case low = 1
    case middling
    case height
    func currentRand(endTime:Date) -> TaskRand {
        let nowDate = Date()
        let secone = endTime.timeIntervalSince1970
        let nowSecone = nowDate.timeIntervalSince1970
        let s = secone - nowSecone
        if s <= 30*60 {
            return .height
        }else if s <= 60*60{
            return .middling
        }else{
             return .low
        }
    }
}

enum TaskType:Int{
    case TaskTypeCommon = 1//普通类型
    case TaskTypeAlert//提醒任务
}

class Task: Object{
    dynamic var creatTime:Date = Date()
    dynamic var taskInfo:String?
    dynamic var endTime:Date?
    dynamic var outTime:Bool = false //是否超时
    dynamic var isFinish:Bool = false
    var taskRand:TaskRand = .low
    
//    override static func primaryKey() -> String? {
//        return "id"
//    }

    
    
}
