//
//  FocusModelViewController.swift
//  WorkList
//
//  Created by zhanfeng on 2017/7/27.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit

class FocusModelViewController: BaseViewController {
    
    private var isFocusModel = false//是否是专注模式
    var backButton:CurstomButton = CurstomButton(type: .custom)
    var timeView:CountTimeView = CountTimeView(frame: CGRect.zero)
    var buttonArray = [UIButton]()
    let timeGrade = ["5","25","50"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupUI() {
        backButton = CurstomButton(type: .custom)
        backButton.addTarget(self, action: #selector(clickBackButton), for: .touchUpInside)
        self.view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        self.view.addSubview(timeView)
        timeView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.right.equalToSuperview()
            make.height.equalTo(timeView.snp.width)
        }
        

        let space = 60
        let btn_w = 30
        let btn_h = 25
        
        let view = UIView(frame: CGRect.zero)
        view.autoresizesSubviews = true
        self.view.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.height.equalTo(btn_h)
            make.top.equalTo(timeView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(210)
        }

        
        var firstButton:UIButton?
        for index in 0...2{
            let button = UIButton(type: .custom)
            button.setTitleColor(UIColor.themeColor, for: .normal)
            button.setTitle(timeGrade[index], for: .normal)
            view.addSubview(button)
            if firstButton == nil {
                firstButton = button
                firstButton?.snp.makeConstraints({ (make) in
                    make.left.equalToSuperview()
                    make.top.bottom.equalToSuperview()
                    make.width.equalTo(btn_w)
                })
            }else{
                let prewBtn = buttonArray[index - 1]
                button.snp.makeConstraints({ (make) in
                    make.left.equalTo(prewBtn.snp.right).offset(space)
                    make.top.bottom.equalToSuperview()
                    make.size.equalTo(btn_w)
                })
            }
            buttonArray.append(button)
        }
        
        let start = UIButton(type: .custom)
        start.setTitle("开 始", for: .normal)
        start.setTitleColor(UIColor.themeColor, for: .normal)
        start.addTarget(self, action: #selector(clickStart), for: .touchUpInside)
        self.view.addSubview(start)
        start.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 80, height: 30))
        }
        
    }
    
    func clickBackButton() {
        if isFocusModel {
            let alertControl = UIAlertController(title: nil, message: "你确定要退出专注模式吗？", preferredStyle: .alert)
            let done = UIAlertAction(title: "确定", style: .default, handler: { (Action) in
                self.quitFocusModel()
            })
            let cancel = UIAlertAction(title: "取消", style: .default, handler: { (Action) in })
            alertControl.addAction(cancel)
            alertControl.addAction(done)
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK:退出专注模式
    func quitFocusModel() {
        isFocusModel = false
        backButton.changeModel = false

    }
    
    func clickStart() {
        if isFocusModel {
            return
        }else{
            isFocusModel = true
            backButton.changeModel = true
        }
    }
    

}

class CurstomButton: UIButton {
    
    private var isFocusModel = false
    
    var changeModel:Bool{
        set{
            if newValue != isFocusModel {
                self.isFocusModel = newValue
                self.setNeedsDisplay()
            }
        }
        get{
            return self.isFocusModel
        }
    }
    
    override func draw(_ rect: CGRect) {
        let beziPath = UIBezierPath()
        beziPath.lineWidth = 1
        UIColor.themeColor.set()
        
        if self.isFocusModel {
            beziPath.move(to: CGPoint(x: 0, y: 0))
            beziPath.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height))
            beziPath.move(to: CGPoint(x: rect.size.width, y: 0))
            beziPath.addLine(to: CGPoint(x: 0, y: rect.size.height))
        }else{
            beziPath.move(to: CGPoint(x: rect.size.width/2, y: 5))
            beziPath.addLine(to: CGPoint(x: rect.size.width/2 - 15, y: rect.size.height/2))
            beziPath.addLine(to: CGPoint(x: rect.size.width/2, y: rect.size.height - 5))
            beziPath.stroke()

        }
    }
}
