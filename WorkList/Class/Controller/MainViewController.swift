//
//  MainViewController.swift
//  WorkList
//
//  Created by zhanfeng on 2017/7/20.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift

class MainViewController: BaseViewController {
    
    fileprivate let DBManager = DataManager()
    fileprivate var taskList:Results<Task>?
    
    var tableView:UITableView{
        let tbw = UITableView(frame: CGRect.zero, style: .plain)
        tbw.backgroundColor = UIColor.white
        tbw.delegate = self
        tbw.dataSource = self
        tbw.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.Identifier)
        self.view.addSubview(tbw)
        tbw.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        return tbw
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let task = Task()
//        task.textInfo = "MainViewController:UITableViewDataSource,UITableViewDelegate"
//        
//        DBManager.insertTask(task: task)
        
        reloadDataBase()

        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func reloadDataBase() {
        taskList = DBManager.queryAlllist()
        tableView.reloadData()
    }
    

}

extension MainViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (taskList?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.Identifier) as! MainTableViewCell
        let task = taskList?[indexPath.row]
        cell.task = task
        cell.addDeleteLine()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let task = taskList?[indexPath.row]
        return (task?.contentHeight(task: task!))!
    }
    
}
