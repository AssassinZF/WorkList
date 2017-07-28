//
//  FocusModelViewController.swift
//  WorkList
//
//  Created by zhanfeng on 2017/7/27.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit

class FocusModelViewController: BaseViewController {
    
    var backButton:CurstomButton = CurstomButton(type: .custom)
    var timeView:CountTimeView = CountTimeView(frame: CGRect.zero)
    var buttonArray = [UIButton]()
    let timeGrade = ["5","25","50"]
    var task:Task?
    
    private lazy var timer:Timer = {
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countTimeAction), userInfo: nil, repeats: true)
        return timer
    }()
    
    private var gradeView:UIView = UIView(frame: CGRect.zero)
    
    private lazy var startButton:UIButton = {
        let start = UIButton(type: .custom)
        start.setTitle("开 始", for: .normal)
        start.isHidden = false
        start.setTitleColor(UIColor.themeColor, for: .normal)
        start.addTarget(self, action: #selector(clickStart), for: .touchUpInside)
        self.view.addSubview(start)
        return start
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.textAlignment = .center
        self.view.addSubview(label)
        return label
    }()
    

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
            make.top.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        self.view.addSubview(timeView)
        timeView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.right.equalToSuperview()
            make.height.equalTo(timeView.snp.width)
        }
        

        self.view.addSubview(gradeView)

        let space = 70
        let btn_w = 30
        let btn_h = 25
        gradeView.snp.makeConstraints { (make) in
            make.height.equalTo(btn_h)
            make.top.equalTo(timeView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(230)
        }
        
        var firstButton:UIButton?
        for index in 0...2{
            let button = UIButton(type: .custom)
            button.setTitleColor(UIColor.themeColor, for: .normal)
            button.setTitle(timeGrade[index], for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(clickSelectTime(btn:)), for: .touchUpInside)
            gradeView.addSubview(button)
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
        
        titleLabel.text = (task?.textInfo)!
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.width.equalTo(kScreenWidth*0.7)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        startButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 80, height: 30))
        }
    }
    
    func clickBackButton() {
        if SingleOnce.shared.isFocusModel {
            let alertControl = UIAlertController(title: nil, message: "你确定要退出专注模式吗？", preferredStyle: .alert)
            let done = UIAlertAction(title: "确定", style: .default, handler: { (Action) in
                self.quitFocusModel()
            })
            let cancel = UIAlertAction(title: "取消", style: .default, handler: { (Action) in })
            alertControl.addAction(cancel)
            alertControl.addAction(done)
            self.present(alertControl, animated: true, completion: nil)
            
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK:退出专注模式
    func quitFocusModel() {
        SingleOnce.shared.isFocusModel = false
        backButton.changeModel = false
        startButton.isHidden = false
        gradeView.isHidden = false
        self.timer.invalidate()
        timeView.countTime = 0
    }
    
    func clickStart() {
        if timeView.countTime > 0{
            SingleOnce.shared.isFocusModel = true
            backButton.changeModel = true
            startButton.isHidden = true
            gradeView.isHidden = true
            self.timer.fire()
        }
    }
    
    //MARK:点击选择时间等级
    func clickSelectTime(btn:UIButton) {
        let selectTime = timeGrade[btn.tag]
        timeView.countTime = Int(selectTime)!
    }
    
    //MARK:倒计时方法
    func countTimeAction() {
        dbugLog(message: "定时器")
        timeView.countTimeAngle()
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
            beziPath.move(to: CGPoint(x: 10, y: 10))
            beziPath.addLine(to: CGPoint(x: rect.size.width - 10, y: rect.size.height - 10))
            beziPath.move(to: CGPoint(x: rect.size.width - 10, y: 10))
            beziPath.addLine(to: CGPoint(x: 10, y: rect.size.height - 10))
            beziPath.stroke()
        }else{
            beziPath.move(to: CGPoint(x: rect.size.width/2, y: 10))
            beziPath.addLine(to: CGPoint(x: rect.size.width/2 - 12, y: rect.size.height/2))
            beziPath.addLine(to: CGPoint(x: rect.size.width/2, y: rect.size.height - 10))
            beziPath.stroke()

        }
    }
}
