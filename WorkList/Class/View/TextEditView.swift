//
//  TextEditView.swift
//  WorkList
//
//  Created by zhanfeng on 2017/7/26.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit

let TextViewSize = CGSize(width: kScreenWidth - 100, height: 100)


class TextEditView: UIView {
    
    lazy var textView:UITextView = {
        let textview = UITextView()
        self.addSubview(textview)
        return textview
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        let hiddenPoint = CGPoint(x: kScreenWidth/2, y: -TextViewSize.height)
        self.bounds = CGRect(origin: CGPoint.zero, size: TextViewSize)
        self.center = hiddenPoint
        self.backgroundColor = UIColor.white
        
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didEditState() {
        textView.becomeFirstResponder()
    }
    
    func showPull(duration:TimeInterval) {
        UIView.springAnimatin(withDuration: duration, delay: 0, animations:{
            self.center = CGPoint(x: kScreenWidth/2, y: TextViewSize.height)
        })
        
    }


}
