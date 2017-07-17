//
//  InputView.swift
//  WorkList
//
//  Created by Daisy on 2017/7/15.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit

public let inputTag = 100

typealias textFinishBlock = (String) -> Void
typealias showDatePickBlock = (Bool)->Void


enum InputType {
    case addTask //添加任务
    case search //搜索
}


public let KIputHeight:CGFloat = 50.0

class InputView: UIView,UITextFieldDelegate {
    
    let backColor = UIColor.flatSandDark
    
    var textFinish:textFinishBlock?
    var showDatePick:showDatePickBlock?
    
    
    var inputType:InputType = .addTask
    var textView:UITextField?
    
    var randomBtn:UIButton?
    
    var isRandom = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tag = inputTag
        var frame = frame
        frame.size = CGSize(width: kScreenWidth, height: KIputHeight)
        frame.origin = CGPoint(x: 0, y: kScreenHeight - KIputHeight)
        self.frame = frame
        self.backgroundColor = backColor
        
        
        let line = UIView(frame: CGRect(x: 10, y:KIputHeight - 5, width: self.sizeW - 20, height: 1))
        line.backgroundColor = UIColor.themeColor
        self.addSubview(line)
        
        let textFieldH = 30.0
        textView = UITextField(frame: CGRect(x: Double(line.originX), y: 10, width: Double(line.sizeW - 40), height: textFieldH))
        textView?.font = UIFont.systemFont(ofSize: 17)
        textView?.attributedPlaceholder = NSAttributedString(string:"我想...",attributes:[NSForegroundColorAttributeName: UIColor.themeColor])
        textView?.tintColor = UIColor.themeColor
        textView?.clearButtonMode=UITextFieldViewMode.whileEditing  //一直显示清除按钮
        textView?.returnKeyType = .done
        textView?.delegate = self
        self.addSubview(textView!)
        
        randomBtn = UIButton(type: .custom)
        randomBtn?.backgroundColor = UIColor.flatBlue
        randomBtn?.addTarget(self, action: #selector(clickRandomTask), for: .touchUpInside)
        randomBtn?.frame = CGRect(x: (textView?.frame.maxX)!+5, y: (textView?.originY)!, width: 30, height: 30)
        self.addSubview(randomBtn!)
    }
    
    func clickRandomTask() {
        isRandom = !isRandom
        if isRandom {
            self.textView?.becomeFirstResponder()
        }else{
            self.textView?.resignFirstResponder()
        }
        
        if (self.showDatePick != nil) {
            self.showDatePick!(isRandom)
        }

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textView?.resignFirstResponder()
        if self.textFinish != nil {
            self.textFinish!(textField.text!)
        }
        self.textView?.text = ""
        return true
    }
    


}
