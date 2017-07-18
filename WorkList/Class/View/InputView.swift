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
typealias jumpSetting = ()->Void


enum InputType {
    case addTask //添加任务
    case search //搜索
    func stringWithType() -> String {
        switch self {
        case .addTask:
            return "我想..."
        case .search:
            return "搜索"
        }
    }
    
    func imageWithType() -> UIImage {
        switch self {
        case .addTask:
            return UIImage.init(named: "suiji")!
        case .search:
            return UIImage.init(named: "settiing")!
        }
    }
}


public let KIputHeight:CGFloat = 50.0

class InputView: UIView,UITextFieldDelegate {
    
    let backColor = UIColor.white
    
    var textFinish:textFinishBlock?
    var showDatePick:showDatePickBlock?
    var jumpSettingVC:jumpSetting?
    
    
    var inputType:InputType = .addTask
    var textView:UITextField?
    
    var randomBtn:UIButton?
    
    var isRandState = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //frame
        self.tag = inputTag
        var frame = frame
        frame.size = CGSize(width: kScreenWidth, height: KIputHeight)
        frame.origin = CGPoint(x: 0, y: kScreenHeight - KIputHeight)
        self.frame = frame
        self.backgroundColor = backColor
        
        self.configureUI()

    }
    
    //configure UI
    func configureUI() {
        
//        let upline = UIView(frame: CGRect(x: 0, y:0, width: self.sizeW, height: 0.5))
//        upline.backgroundColor = UIColor.themeColor
//        self.addSubview(upline)

        
        let line = UIView(frame: CGRect(x: 10, y:KIputHeight - 5, width: self.sizeW - 20, height: 1))
        line.backgroundColor = UIColor.themeColor
        self.addSubview(line)
        
        
        let textFieldH = 30.0
        textView = UITextField(frame: CGRect(x: Double(line.originX), y: 10, width: Double(line.sizeW - 40), height: textFieldH))
        textView?.font = UIFont.systemFont(ofSize: 17)
        textView?.attributedPlaceholder = NSAttributedString(string:inputType.stringWithType(),attributes:[NSForegroundColorAttributeName: UIColor.themeColor])
        textView?.tintColor = UIColor.themeColor
        textView?.clearButtonMode=UITextFieldViewMode.whileEditing  //一直显示清除按钮
        textView?.returnKeyType = .done
        textView?.delegate = self
        self.addSubview(textView!)
        
        randomBtn = UIButton(type: .custom)
        randomBtn?.addTarget(self, action: #selector(clickRandomTask), for: .touchUpInside)
        randomBtn?.frame = CGRect(x: (textView?.frame.maxX)!+5, y: (textView?.originY)!, width: 30, height: 30)
        randomBtn?.setImage(inputType.imageWithType(), for: .normal)
        self.addSubview(randomBtn!)

    }
    
    func clickRandomTask() {
        if inputType == .search {
            print("jump settingVC")
            if (self.jumpSettingVC != nil) {
                self.jumpSettingVC!()
            }
            return
        }
        if isRandState {
            if !(self.textView?.isFirstResponder)! {
                self.textView?.becomeFirstResponder()
            }
            textView?.text = "我是随机数据"
            randomBtn?.setImage(UIImage.init(named: "naozhong"), for: .normal)
            isRandState = false

        }else{
            // show ⏰
            if (textView?.isFirstResponder)! {
                textView?.resignFirstResponder()
                if (self.showDatePick != nil) {
                    self.showDatePick!(true)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hidenDatePick() {
        self.textView?.becomeFirstResponder()
    }
    
    //MARK: change input type
    func changeInputViewType(type:InputType) {
        self.inputType = type
        textView?.attributedPlaceholder = NSAttributedString(string:inputType.stringWithType(),attributes:[NSForegroundColorAttributeName: UIColor.themeColor])
        randomBtn?.setImage(inputType.imageWithType(), for: .normal)
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        // hidden datePick
        if (self.showDatePick != nil) {
            self.showDatePick!(false)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.textFinish != nil {
            self.textFinish!(textField.text!)
            self.textView?.text = ""
        }
        randomBtn?.setImage(UIImage.init(named: "suiji"), for: .normal)
        isRandState = true
        textView?.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if self.inputType == .addTask {
            randomBtn?.setImage(UIImage.init(named: "suiji"), for: .normal)
            isRandState = true
        }
        return true
    }
    


}
