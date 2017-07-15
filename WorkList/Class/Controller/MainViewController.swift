//
//  MainViewController.swift
//  WorkList
//
//  Created by Daisy on 2017/7/15.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    var myTableView:UITableView?
    var dataSource = [Task]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupUI(){
        
        myTableView = UITableView(frame: self.view.bounds, style: .plain)
        myTableView?.dataSource = self
        myTableView?.delegate = self
        self.view.addSubview(myTableView!)
        myTableView?.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.ReuseIdentifier)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:UITableViewDataSource,UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TaskTableViewCell = TaskTableViewCell(style: .default, reuseIdentifier: TaskTableViewCell.ReuseIdentifier)
        return cell
    }
    
}
