//
//  DatePickView.swift
//  WorkList
//
//  Created by zhanfeng on 2017/7/17.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit

enum TimeSelect:Int{
    case none = 1
    case everyDay
    case everyWeek
    case everyMonth
    case everyYear
}


class DatePickView: UIView {
    
    let viewH:CGFloat = 550.0/2
    
    typealias selectDateClosure = (Date?,TimeSelect?,Bool)->Void
    var clickSelectDate:selectDateClosure?
    
    var datePick:UIDatePicker?
    
    var timeType:TimeSelect = .none
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var newFrame = frame
        newFrame.origin = CGPoint(x: 0, y: kScreenHeight - viewH)
        newFrame.size = CGSize(width: kScreenWidth, height: viewH)
        self.frame = newFrame
        
        self.backgroundColor = UIColor.white
        
        let leftF = CGRect(x: 15, y: 5, width: 80, height: 25)
        let rightF = CGRect(x: kScreenWidth - 80 - 15, y: 5, width: 80, height: 30)
        let leftbtn = creatButton(title: "取消", action: #selector(clickCancel(sender:)))
        let rightbtn = creatButton(title: "完成", action: #selector(clickDone(sender:)))
        leftbtn.frame = leftF
        rightbtn.frame = rightF
        self.addSubview(leftbtn)
        self.addSubview(rightbtn)
        
        
        datePick = UIDatePicker(frame: CGRect(x: 0, y: 30, width: kScreenWidth, height: viewH - 30))
        datePick?.locale = NSLocale.init(localeIdentifier: "zh_CN") as Locale;//中文
        datePick?.backgroundColor = UIColor.lightGray;
        datePick?.datePickerMode = UIDatePickerMode.dateAndTime;//日期和时间
        datePick?.date = Date();
        self.addSubview(datePick!)
        
    }
    
    func clickCancel(sender:Any) {
        hidenView()
        if clickSelectDate != nil{
            clickSelectDate!(nil,nil,false)
        }
        
    }
    
    func clickDone(sender:Any) {
        hidenView()
        if clickSelectDate != nil{
            clickSelectDate!(datePick?.date,timeType,true)
        }

    }
    
    func hidenView() {
        UIView.animate(withDuration: animationTime) { 
            var f = self.frame
            f.origin.y = kScreenHeight
            self.frame = f
        }
    }
    
    func creatButton(title:String,action:Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.themeColor, for: .normal)
        return button
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
