//
//  ClockView.swift
//  WorkList
//
//  Created by zhanfeng on 2017/7/26.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit

let ClockHeight:CGFloat = 275

let lefTag = 0
let doneTag = 1

class ClockView: UIView {
    
    var clickButtonBlock:((Int,Date) -> Void)?
    
    var  selectDate:Date = Date()
    
    
    init() {
        let frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: ClockHeight)
        super.init(frame: frame)
        self.frame = frame
        self.backgroundColor = UIColor.white
        
        let topLine = UIView(frame: CGRect(x: 0, y: 35, width: kScreenWidth - 20, height: 1))
        topLine.backgroundColor = UIColor.subTextColor
        topLine.center = CGPoint(x: kScreenWidth/2, y: 35 + 0.5)
        self.addSubview(topLine)
        
        let leftButton = UIButton(type: .custom)
        leftButton.setTitle("取消", for: .normal)
        leftButton.setTitleColor(UIColor.textColor, for: .normal)
        leftButton.tag = lefTag
        leftButton.frame = CGRect(x: 10, y: 5, width: 80, height: 30)
        leftButton.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        self.addSubview(leftButton)
        
        let doneButton = UIButton(type: .custom)
        doneButton.setTitle("完成", for: .normal)
        doneButton.setTitleColor(UIColor.textColor, for: .normal)
        doneButton.tag = doneTag
        doneButton.frame = CGRect(x: kScreenWidth - 90, y: 5, width: 80, height: 30)
        doneButton.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        self.addSubview(doneButton)
        
        let datePick = UIDatePicker(frame: CGRect.zero)
        datePick.locale = Locale(identifier: "zh_CN")
        datePick.addTarget(self, action: #selector(dateChanged),
                             for: .valueChanged)
        datePick.frame = CGRect(x: 0, y: 36, width: kScreenWidth, height: ClockHeight - 36)
        self.addSubview(datePick)
    
    }
    
    func showClockView(isShow:Bool) {
        UIView.animate(withDuration: 0.3) { 
            var f = self.frame
            f.origin.y = isShow ? kScreenHeight - ClockHeight : kScreenHeight
            self.frame = f
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func dateChanged(datePicker : UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        dbugLog(message: formatter.string(from: datePicker.date))
        selectDate = datePicker.date
    }
    
    func buttonClick(button:UIButton) {
        if let clickMethod = clickButtonBlock {
            clickMethod(button.tag,selectDate)
        }
        
        UIView.animate(withDuration: 0.3) {
            var f = self.frame
            f.origin.y = kScreenHeight
            self.frame = f
            
        }
    }


}
