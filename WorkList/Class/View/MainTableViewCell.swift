//
//  MainTableViewCell.swift
//  WorkList
//
//  Created by zhanfeng on 2017/7/21.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit
import SwipeCellKit

let textFont:UIFont = UIFont.systemFont(ofSize: 15)
let timeFont:UIFont = UIFont.systemFont(ofSize: 11)

let textMinHeight:CGFloat = 25
let endTimeHeight:CGFloat = 15
let topSpace:CGFloat = 10
let leftSpace:CGFloat = 25


class MainTableViewCell: SwipeTableViewCell {
    
    static let Identifier: String = NSStringFromClass(MainTableViewCell.self)
    
    fileprivate var taskText:UILabel?
    fileprivate var endTimeLabel:UILabel?
    public var task:Task?{
        didSet{
            updateCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.selectionStyle = .none
        
        taskText = UILabel()
        taskText?.font = textFont
        taskText?.numberOfLines = 0
        taskText?.textColor = UIColor.textColor
        taskText?.sizeToFit()
        self.addSubview(taskText!)
        taskText?.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(leftSpace)
            make.top.equalToSuperview().offset(topSpace)
            make.right.equalToSuperview().offset(-leftSpace)
            make.height.equalTo(leftSpace*2)
        }
        endTimeLabel = UILabel()
        endTimeLabel?.font = timeFont
        endTimeLabel?.textColor = UIColor.flatRed
        self.addSubview(endTimeLabel!)
        endTimeLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(taskText!)
            make.top.equalTo(taskText!.snp.bottom)
            make.height.equalTo(endTimeHeight)
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK:update cell
extension MainTableViewCell{
    
     func updateCell() {
        self.taskText?.text = self.task?.textInfo
        self.endTimeLabel?.text = Date.stringWithCurrentDate()
        
        let maxHeight = UILabel.getLabHeight(labelStr: (taskText?.text)! as NSString, font: (taskText?.font)!, width: kScreenWidth - leftSpace*2)
        let height = max(maxHeight, textMinHeight)
        self.taskText?.snp.updateConstraints({ (make) in
            make.height.equalTo(height)
        })
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    //MARK:左滑删除任务
    func addDeleteLine() {
        self.taskText?.textColor = UIColor.flatGray
        let attributeStr = NSMutableAttributedString(string:(self.taskText?.text)!)
        attributeStr.addAttributes([NSBaselineOffsetAttributeName:0,NSStrikethroughStyleAttributeName:1], range: NSMakeRange(0, attributeStr.length))
        self.taskText?.attributedText = attributeStr
    }

}









