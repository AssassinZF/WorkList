//
//  Delay.swift
//  WorkList
//
//  Created by Daisy on 2017/7/16.
//  Copyright © 2017年 lzf. All rights reserved.
//

import Foundation

typealias TaskF = (_ cancel : Bool) -> Void


func delay(_ time: TimeInterval, task: @escaping ()->()) ->  TaskF? {
    
    func dispatch_later(block: @escaping ()->()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    var closure: (()->Void)? = task
    var result: TaskF?
    
    let delayedClosure: TaskF = {
        cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    return result
}

func cancel(_ task: TaskF?) {
    task?(true)
}
