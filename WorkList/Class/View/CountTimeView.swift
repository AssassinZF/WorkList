//
//  CountTimeView.swift
//  WorkList
//
//  Created by zhanfeng on 2017/7/27.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit

let Radius = 150

class CountTimeView: UIView {
    
    var currentTime:Int = 0
    
    var setCurrentTime:Int{
        set{
            currentTime = newValue
        }
        get{
            return self.currentTime
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.purple
        creatPanGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func creatPanGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panActor(pan:)))
        self.addGestureRecognizer(pan)
    }
    
    func panActor(pan:UIGestureRecognizer) {
        let point = pan.location(in: self)
        dbugLog(message: point)
    
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(arcCenter: CGPoint(x: rect.size.width/2, y: rect.size.height/2),
                                radius: 150,
                                startAngle: 0,
                                endAngle: 270,
                                clockwise: true)
        path.lineWidth = 5
        UIColor.themeColor.set()
        path.stroke()
        
        let timeString:NSString = self.stringWitTimeCount() as NSString
//        timeString.draw(in: CGPoint(x: rect.size.width/2, y: rect.size.height/2), with: [NSFontAttributeName:UIFont.systemFont(ofSize: 35)],lineBreakMode: [NSForegroundColorAttributeName:UIColor.themeColor])
        
        timeString.draw(at: CGPoint(x: rect.size.width/2, y: rect.size.height/2), withAttributes: nil)
    }
    
    func stringWitTimeCount() -> String {
        guard currentTime > 0 else {
            return "00:00"
        }
        var timeString:String = "00:00"
        let hours = currentTime%60
        if hours > 0 {
            timeString = "\(hours):"
        }else{
            timeString = "00:"
        }
        let minute = currentTime/60
        if minute > 0 && minute < 10{
            timeString = timeString + "0\(minute):"
        }else{
            timeString = timeString + "\(minute):"
        }
        timeString = timeString + "00"
        
        return timeString
        
    }

}
