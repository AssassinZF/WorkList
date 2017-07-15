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
enum TaskRand{
    case low
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


class Task: Object{
    var creatTime:Date = Date()
    var taskInfo:String?
    var endTime:Date?
    var outTime:Bool = false
    var taskRand:TaskRand = .low
    
    
    init(taskInfo:String,endTime:Date?) {
        self.taskInfo = taskInfo
        self.endTime = endTime
        self.taskRand = self.taskRand.currentRand(endTime: endTime!)
    }
    
    
    

}
