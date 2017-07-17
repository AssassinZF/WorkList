//
//  DataManager.swift
//  WorkList
//
//  Created by Daisy on 2017/7/15.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit
import RealmSwift

class DataManager: NSObject {
    
    let DB = try! Realm()
    
    override init() {
        super.init()
        printDBPath()
    }
    
    func insertTask(task:Task){
        try! DB.write {
            DB.add(task)
        }
    }
    
    func deleteTask(task:Task) {
        try! DB.write {
            DB.delete(task)
        }
    }
    
    func updatae(task:Task) {
        try! DB.write {
            DB.add(task, update: true)
        }
    }
    
    func queryAlllist() -> Results<Task> {
        let lists = DB.objects(Task.self)
        return lists
    }


    func printDBPath() {
        dbugLog(message: "数据库路径：\(DB.configuration.fileURL!)")
    }
    

}
