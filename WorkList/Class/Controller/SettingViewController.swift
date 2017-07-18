//
//  SettingViewController.swift
//  WorkList
//
//  Created by zhanfeng on 2017/7/18.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let closeBtn = UIButton(type: .custom)
        closeBtn.setImage(UIImage.init(named: "close.png"), for: .normal)
        closeBtn.frame = CGRect(x: 10, y: 10, width: 40, height: 40)
        closeBtn.addTarget(self, action: #selector(clickCloseVC), for: .touchUpInside)
        self.view.addSubview(closeBtn)
    }
    
    func clickCloseVC(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
