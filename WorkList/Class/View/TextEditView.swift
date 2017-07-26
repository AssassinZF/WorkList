//
//  TextEditView.swift
//  WorkList
//
//  Created by zhanfeng on 2017/7/26.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit

let TextViewSize = CGSize(width: kScreenWidth, height: 250)
let TextViewFont = UIFont.systemFont(ofSize: 20)

class TextEditView: UIView{
    
    lazy var textView:UITextView = {
        let textview = UITextView()
        textview.returnKeyType = .done;
        textview.backgroundColor = UIColor.clear
        textview.font = TextViewFont
        self.addSubview(textview)
        let placeHolderLabel = UILabel()
        placeHolderLabel.text = "我想..."
        placeHolderLabel.font = TextViewFont
        placeHolderLabel.textColor = UIColor.subTextColor
        textview.addSubview(placeHolderLabel)
        textview.setValue(placeHolderLabel, forKey: "_placeholderLabel")
        return textview
    }()
    
    lazy var textLine:UIView = {
        let line = UIView(frame: CGRect.zero)
        line.backgroundColor = UIColor.subTextColor
        line.isHidden = true
        self.addSubview(line)
        return line
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        self.bounds = CGRect(origin: CGPoint.zero, size: TextViewSize)
        self.center = CGPoint(x: kScreenWidth/2, y: TextViewSize.height/2)
        self.isHidden = true
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 30, left: 10, bottom: 120, right: 10))
        }
        
        textLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(textView)
            make.top.equalTo(textView.snp.bottom).offset(2)
            make.height.equalTo(1)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showPull(duration:TimeInterval) {
        UIView.animate(withDuration: duration) { 
            self.isHidden = false
        }
    }
    
    func showLine() {
        textLine.isHidden = false
    }
}
