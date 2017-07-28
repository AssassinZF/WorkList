//
//  CountTimeView.swift
//  WorkList
//
//  Created by zhanfeng on 2017/7/27.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit

let Radius = 150
let Max_time = 120*60 //

class CountTimeView: UIView {
    
    private var shapeLayer = CAShapeLayer()
    
    private var currentTime:Int = 0
    
    private var lastPointy:CGFloat = 0
    
    private var totalTime:Int = 0
    
    var countTime:Int{
        set{
            currentTime = newValue*60
            self.setNeedsDisplay()
        }
        get{
            return self.currentTime
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        creatPanGesture()
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.themeColor.cgColor
        shapeLayer.lineWidth = 5
        self.layer.addSublayer(shapeLayer)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func creatPanGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panActor(pan:)))
        self.addGestureRecognizer(pan)
    }
    
    func panActor(pan:UIGestureRecognizer) {
        
        if SingleOnce.shared.isFocusModel {
            return
        }
        let point = pan.location(in: self)
        
        if pan.state == .began {
            lastPointy = 0
            lastPointy = point.y
        }else if pan.state == .changed{
            let offy = lastPointy - point.y
            if offy > 0{
                //增加
                currentTime += Int(offy)*60
                if currentTime > Max_time {
                    currentTime = Max_time
                }
            }else{
                //减少
                currentTime += Int(offy)*60
                if currentTime < 0 {
                    currentTime = 0
                }
            }
            lastPointy = point.y
            self.setNeedsDisplay()
        }
        totalTime = currentTime
        dbugLog(message: currentTime)

    }
    
    func countTimeAngle(){
        currentTime -= 1 //每次减少一秒
        let angle:Double = Double.pi*2*Double(currentTime)/Double(totalTime)
        let path = getPathWithAngle(angle: CGFloat(angle))
        shapeLayer.path = path
        self.setNeedsDisplay()
    }
    
    
    func getPathWithAngle(angle:CGFloat) -> CGPath {
        
        let radius: CGFloat = 150.0
        let startAngle: CGFloat = CGFloat(-(Double.pi/2))
        let endAngle: CGFloat = angle
        
        let path = UIBezierPath(arcCenter: CGPoint(x: self.sizeW/2, y: self.sizeH/2),
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        return path.cgPath

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shapeLayer.path = getPathWithAngle(angle: CGFloat(Double.pi*2))
    }
    
    
    override func draw(_ rect: CGRect) {
        
        let radius: CGFloat = 150.0
        let startAngle: CGFloat = CGFloat(-(Double.pi/2))
        let endAngle: CGFloat = CGFloat(Double.pi*2)
        
        let path = UIBezierPath(arcCenter: CGPoint(x: self.sizeW/2, y: self.sizeH/2),
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        path.lineWidth = 5
        UIColor.subTextColor.set()
        path.stroke()

        
        let timeString:NSString = self.stringWitTimeCount() as NSString
        
        let attribute = [NSFontAttributeName:UIFont.systemFont(ofSize: 50),NSForegroundColorAttributeName:UIColor.themeColor]
        let size = timeString.size(attributes: attribute)
        timeString.draw(at: CGPoint(x: rect.size.width/2 - size.width/2, y: rect.size.height/2 - size.height/2), withAttributes: attribute)
    }
    
    func stringWitTimeCount() -> String {
        guard currentTime > 0 else {
            return "00:00"
        }
        var timeString:String = "00:00"
        let hours = currentTime/60/60
        if hours > 0 {
            timeString = "\(hours):"
        }else{
            timeString = ""
        }
        let second = currentTime - hours*60*60//除去小时剩余秒数
        
        let minute = second/60
        if  minute < 10{
            timeString = timeString + "0\(minute):"
        }else {
            timeString = timeString + "\(minute):"
        }
        

        if SingleOnce.shared.isFocusModel {
            
            let lastSecond = second%60//倒计时秒数
            if lastSecond < 10 {
                timeString = timeString + "0\(lastSecond)"
            }else{
                timeString = timeString + "\(lastSecond)"
            }
            
        }else{
//            let lastSecond = second%60
//            currentTime -= lastSecond
            timeString = timeString + "00"
        }
        
        
        return timeString
        
    }

}
