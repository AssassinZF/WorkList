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
import SwipeCellKit


class MainViewController: BaseViewController {
    
    var isSwipeRightEnabled = false//cell 禁止 右扫

    
    fileprivate let DBManager = DataManager()
    lazy fileprivate var taskList:Array<Task> = {
        return [Task]()
    }()
    
    fileprivate lazy var tableView:UITableView = {
        [unowned self] in
        let tbw = UITableView(frame: CGRect.zero, style: .plain)
        tbw.backgroundColor = UIColor.white
        tbw.delegate = self
        tbw.dataSource = self
        tbw.tableFooterView = UIView()
        tbw.separatorStyle = .none
        tbw.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.Identifier)
        self.view.addSubview(tbw)
        tbw.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        return tbw
    }()
    
    fileprivate lazy var wirteBtn:EditButton = {
        [unowned self] in
        let btn = EditButton(frame: CGRect.zero)
        btn.clickDelegate = self
        self.view.addSubview(btn)
        self.view.bringSubview(toFront: btn)
        return btn
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadDataBase()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        wirteBtn.showWithAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func reloadDataBase() {
        self.taskList.removeAll()
        let result:Results<Task> = DBManager.queryAlllist()
        var index = 0
        repeat {
            let item = result[index]
            self.taskList.append(item)
            index += 1
        } while index < result.count
        
        tableView.reloadData()
    }
    

}

//MARK: TableViewDelegate Method
extension MainViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.Identifier) as! MainTableViewCell
        let task = taskList[indexPath.row]
        cell.task = task
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let task = taskList[indexPath.row]
        return task.contentHeight(task: task)
    }
    
}

//MARK:Custom cell swipe Protocol
extension MainViewController: SwipeTableViewCellDelegate{
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .left {
            return nil
        }
        
        let delete = SwipeAction(style: .destructive, title: nil) { (ation, indexPatch) in
            self.deleteTask(indexPath: indexPath)
        }
        delete.image = #imageLiteral(resourceName: "delete.png")
        
        let reEdit = SwipeAction(style: .default, title: nil) { (action, indexPath) in
            print("reedit")
        }
        reEdit.image = #imageLiteral(resourceName: "reEdit.png")
        
        delete.backgroundColor = UIColor.white
        reEdit.backgroundColor = delete.backgroundColor!
        
        return [delete,reEdit]
    }
    
    //MARK: 重新编辑任务
    func reEditTask(indexPath:IndexPath) {
        
    }
    
    //MARK:delete task 
    func deleteTask(indexPath:IndexPath) {
        guard indexPath.row <= self.taskList.count else {
            return
        }
        let deleteTask = self.taskList.remove(at: indexPath.row)
        self.tableView.reloadData()
        DBManager.deleteTask(task: deleteTask)

    }

}

//MARK:button click delegate
extension MainViewController:EditButtonDelegate{
    
    func clickAction(editButton: EditButton) {
        switch editButton.btnType {
        case .edit:
            self.wirteBtn.animationChange(time: 0.5, isDown:true, addHeight: 0)
        case .random:
            self.wirteBtn.animationChange(time: 0.5, isDown: false, addHeight: 221)
        default:
            dbugLog(message: "")
        }
    }
}




