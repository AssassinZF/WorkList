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
    
}

extension UIView{
    
    var originX:CGFloat{ return self.frame.origin.x }
    var originY:CGFloat{ return self.frame.origin.y }
    
    var sizeW:CGFloat{ return self.frame.size.width }
    var sizeH:CGFloat{ return self.frame.size.height }
    
    
    
    
}
