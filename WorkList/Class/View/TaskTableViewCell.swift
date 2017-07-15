//
//  TaskTableViewCell.swift
//  WorkList
//
//  Created by Daisy on 2017/7/15.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    var task:Task?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK: extension
extension TaskTableViewCell{
    static var ReuseIdentifier:String{return "TaskTableViewCell"}
    
}
