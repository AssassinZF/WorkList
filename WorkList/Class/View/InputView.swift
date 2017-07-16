//
//  InputView.swift
//  WorkList
//
//  Created by Daisy on 2017/7/15.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit

let inputTag = 100

enum InputType {
    case addTask //添加任务
    case search //搜索
}

let KIputHeight:CGFloat = 44.0
private let backColor = UIColor.purple

class InputView: UIView {
    
    var inputType:InputType = .addTask
    var textView:UITextView?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tag = inputTag
        var frame = frame
        frame.size = CGSize(width: kScreenWidth, height: KIputHeight)
        frame.origin = CGPoint(x: 0, y: kScreenHeight - KIputHeight)
        self.frame = frame
        self.backgroundColor = backColor
        
        textView = UITextView(frame: self.frame)
        self.addSubview(textView!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    


}
