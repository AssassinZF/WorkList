//
//  EditButton.swift
//  WorkList
//
//  Created by zhanfeng on 2017/7/24.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit

let btnSize = CGSize(width: 44, height: 44)
let btnOrigin = CGPoint(x: kScreenWidth/2 - btnSize.width/2, y: kScreenHeight - btnSize.width*1.5)

enum ButtonType {
    case normal,random,clock
    
    func backImage() -> UIImage {
        switch self {
        case .normal:
            return #imageLiteral(resourceName: "write.png")
        case .random:
            return UIImage.init(named: "suiji.png")!
        case .clock:
            return UIImage.init(named: "naozhong.png")!
        }
    }
    
    func next() -> ButtonType {
        switch self {
        case .normal:
            return .random
        case .random:
            return .clock
        case .clock:
            return .clock
        }
    }
}

protocol EditButtonDelegate{
    func clickAction(editButton:EditButton)
}

class EditButton: UIButton {
    
    var btnType:ButtonType = .normal{
        didSet{
            self.setImage(btnType.backImage(), for: .normal)
        }
    }
    
    var clickDelegate:EditButtonDelegate?
    
    var isDown = true
    
    override init(frame: CGRect) {
        let f = CGRect(origin: btnOrigin, size: btnSize)
        super.init(frame: f)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.subTextColor.cgColor
        self.layer.cornerRadius = btnSize.width/2
        self.setImage(btnType.backImage(), for: .normal)
//        self.layer.shadowOpacity = 0.5
//        self.layer.shadowColor = UIColor.flatBlack.cgColor
//        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clickButton() {
        if clickDelegate != nil {
            clickDelegate!.clickAction(editButton: self)
        }
    }
    
    func showWithAnimation() {
        
//        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
//            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//
//        }, completion: nil)
        
        self.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.5,
                       animations: { 
                        self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { (completion) in
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)

            })
            
        }
    }
    
    func animationChange(time:TimeInterval,isDown:Bool,addHeight:CGFloat) {
        let tagerOrigin = CGPoint(x: btnOrigin.x, y: isDown ? btnOrigin.y : btnOrigin.y - addHeight)
        UIView.springAnimatin(withDuration: 0.5, delay: 0, animations: {
            var frame = self.frame
            frame.origin = tagerOrigin
            self.frame = frame
        })
    }

}
