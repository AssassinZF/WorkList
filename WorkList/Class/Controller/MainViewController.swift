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
    
    fileprivate lazy var textEditView:TextEditView = {
        [unowned self] in
        let editView = TextEditView()
        self.view.addSubview(editView)
        return editView
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    //MARK: 模糊背景处理
    fileprivate func visualEffectView() {
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
        effectView.frame = self.view.frame;
        self.view.addSubview(effectView)
        self.view.bringSubview(toFront: self.wirteBtn)
    }
    

}

//MARK: TableViewDelegate Method
extension MainViewController:UITableViewDataSource,UITableViewDelegate{
    
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
            self.textEditView.didEditState()
            visualEffectView()

        default:
            dbugLog(message: "")
        }
    }
}

//MARK: 键盘监听处理
extension MainViewController{
    
    fileprivate func addKeyboardNotifiter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //键盘的出现
    @objc private func keyBoardWillShow(_ notification: Notification){
        //获取userInfo
        let kbInfo = notification.userInfo
        //获取键盘的size
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //键盘弹出的时间
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        self.textEditView.showPull(duration: duration)
        
        self.wirteBtn.animationChange(time: duration, isDown: false, addHeight: kbRect.height)

        
    }
    
    //键盘的隐藏
    @objc private func keyBoardWillHide(_ notification: Notification){
//        let kbInfo = notification.userInfo
//        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let changeY = kbRect.origin.y
//        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
    }

}



