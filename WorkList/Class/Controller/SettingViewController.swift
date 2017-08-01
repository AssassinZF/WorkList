//
//  SettingViewController.swift
//  WorkList
//
//  Created by zhanfeng on 2017/8/1.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismisVC(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
