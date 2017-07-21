//
//  MainTableViewCell.swift
//  WorkList
//
//  Created by zhanfeng on 2017/7/21.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit

let textFont:UIFont = UIFont.systemFont(ofSize: 15)

let textMinHeight:CGFloat = 30
let endTimeHeight:CGFloat = 15
let topSpace:CGFloat = 15
let leftSpace:CGFloat = 15


class MainTableViewCell: UITableViewCell {
    
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
        
        taskText = UILabel()
        taskText?.font = UIFont.systemFont(ofSize: 17)
        taskText?.numberOfLines = 0
        taskText?.backgroundColor = UIColor.flatGray
        taskText?.sizeToFit()
        self.addSubview(taskText!)
        taskText?.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(leftSpace)
            make.right.equalToSuperview().offset(-leftSpace)
            make.height.equalTo(leftSpace*2)
        }
        endTimeLabel = UILabel()
        endTimeLabel?.font = UIFont.systemFont(ofSize: 12)
        taskText?.backgroundColor = UIColor.flatMint
        self.addSubview(endTimeLabel!)
        endTimeLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(textLabel!)
            make.top.equalTo(textLabel!.snp.bottom)
            make.height.equalTo(leftSpace)
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK:update cell
extension MainTableViewCell{
    
    fileprivate func updateCell() {
        self.taskText?.text = self.task?.textInfo
        
        
        let maxHeight = UILabel.getLabHeight(labelStr: (taskText?.text)! as NSString, font: (taskText?.font)!, width: kScreenWidth - leftSpace*2)
        let height = max(maxHeight, textMinHeight)
        self.taskText?.snp.updateConstraints({ (make) in
            make.left.top.equalToSuperv iew().offset(leftSpace)
            make.right.equalToSuperview().offset(-leftSpace)
            make.height.equalTo(height)
        })
        print(height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func addDeleteLine() {
        let lineStr = NSAttributedString(string: (self.taskText?.text)!,attributes: [NSStrikethroughStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue])
        self.taskText?.attributedText = lineStr
    }

}









