//
//  UILabel+Extension.swift
//  WorkList
//
//  Created by zhanfeng on 2017/7/21.
//  Copyright © 2017年 lzf. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
    
    static func getLabHeight(labelStr:NSString,font:UIFont,width:CGFloat) -> CGFloat {
        
        let priceStr = labelStr
        let attributes = [NSFontAttributeName:font]
        let size = priceStr.boundingRect(with: CGSize.init(width: width, height: 1000), options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
        return size.height+5
        
        
        
//        let statusLabelText: NSString = labelStr
//        let size = CGSize(width: width, height: 900.0)
//        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
//        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : Any], context: nil).size
//        return strSize.height
    }
    
    
    
}
