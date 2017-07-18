//
//  Color.swift
//  WorkList
//
//  Created by Daisy on 2017/7/15.
//  Copyright © 2017年 lzf. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework

extension UIColor{
    static var themeColor:UIColor{ return UIColor.flatGray}
    static var mainBackColor:UIColor{ return UIColor.white }
    
    //rgb color
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

extension UIView{
    
    var originX:CGFloat{ return self.frame.origin.x }
    var originY:CGFloat{ return self.frame.origin.y }
    
    var sizeW:CGFloat{ return self.frame.size.width }
    var sizeH:CGFloat{ return self.frame.size.height }
    
    
    
    
}
