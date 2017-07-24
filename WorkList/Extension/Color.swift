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
    static var textColor:UIColor{
        return self.colorWithHexString(hex: "515151")
    }
    static var subTextColor:UIColor{
        return self.colorWithHexString(hex: "8a8a8a")
    }
    
    //16 进制
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // hex strin
    class func colorWithHexString(hex:String) ->UIColor {
        
        var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            let index = cString.index(cString.startIndex, offsetBy:1)
            cString = cString.substring(from: index)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.red
        }
        
        let rIndex = cString.index(cString.startIndex, offsetBy: 2)
        let rString = cString.substring(to: rIndex)
        let otherString = cString.substring(from: rIndex)
        let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
        let gString = otherString.substring(to: gIndex)
        let bIndex = cString.index(cString.endIndex, offsetBy: -2)
        let bString = cString.substring(from: bIndex)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }

    
}

extension UIView{
    
    var originX:CGFloat{ return self.frame.origin.x }
    var originY:CGFloat{ return self.frame.origin.y }
    
    var sizeW:CGFloat{ return self.frame.size.width }
    var sizeH:CGFloat{ return self.frame.size.height }
    
    class func springAnimatin(withDuration duration: TimeInterval, delay: TimeInterval,animations: @escaping () -> Swift.Void, completion: ((Bool) -> Swift.Void)? = nil){
        
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: animations, completion: completion)
        
    }
}
