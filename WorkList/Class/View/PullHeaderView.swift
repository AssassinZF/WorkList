//
//  PullHeaderView.swift
//  WorkList
//
//  Created by zhanfeng on 2017/7/26.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit

let Header_h:CGFloat = 60

class PullHeaderView: UIView {
    
    var offy:CGFloat = 0//下拉偏移量
    
    var setOffy:CGFloat{
        set{
            self.offy = newValue
            if newValue >= 0 {
                self.setNeedsDisplay()
            }
        }
        get{
            return self.offy
        }
    }
    
    
    
    init() {
        let frame = CGRect(x: 0, y: -Header_h, width: kScreenWidth, height: Header_h)
        super.init(frame: frame)
        self.frame = frame
        self.backgroundColor = UIColor.white
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let lineW:CGFloat = 35

        if self.offy < lineW/2 {
            return
        }
        let beziPath = UIBezierPath()
        beziPath.lineWidth = 1
        UIColor.themeColor.set()
        
        let leftPoint = CGPoint(x: self.sizeW/2 - lineW/2, y: self.sizeH - lineW/2)
        let rightPoint = CGPoint(x: self.sizeW/2 + lineW/2, y: self.sizeH - lineW/2)
        let center = CGPoint(x: self.sizeW/2, y: self.sizeH - lineW/2)

        if self.offy < lineW+lineW/2 {
            beziPath.move(to: center)
            //获取左右前进点
            var leftP = leftPoint
            leftP.x = self.sizeW/2 - self.offy/3
            var rightP = rightPoint
            rightP.x = self.sizeW/2 + self.offy/3
            
            beziPath.addLine(to: leftP)
            beziPath.move(to: center)
            beziPath.addLine(to: rightP)
            beziPath.stroke()
        }else{
            var cent = center
            cent.y = (self.sizeH - lineW/2) + (self.offy - (lineW + lineW/2))/2
            if cent.y >= self.sizeH - lineW/4 {
                cent.y = self.sizeH - lineW/4
            }
            beziPath.move(to: cent)
            beziPath.addLine(to: leftPoint)
            beziPath.move(to: cent)
            beziPath.addLine(to: rightPoint)
            beziPath.stroke()
        }
    }
    

}
