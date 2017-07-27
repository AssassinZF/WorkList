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
    var keyboardDuration:TimeInterval?//保存键盘动画时间
    var pullHeaderView:PullHeaderView?
    
    fileprivate let DBManager = DataManager()
    
    fileprivate lazy var taskList:Array<Task> = {
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
        editView.textView.delegate = self
        self.view.addSubview(editView)
        self.view.bringSubview(toFront: editView)
        return editView
    }()
    
    //模糊背景
    fileprivate lazy var effectView:UIVisualEffectView = {
        [unowned self] in
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
        effectView.frame = self.view.frame;
        self.view.addSubview(effectView)
        return effectView
    }()
    
    fileprivate lazy var clockView:ClockView = {
        [unowned self] in
        let clockView = ClockView()
        self.view.addSubview(clockView)
        return clockView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加tableview 下拉视图
        pullHeaderView = PullHeaderView()
        self.tableView.addSubview(pullHeaderView!)
        
        //从数据库读取所有没有完成的任务
        reloadDataBase()
        
        //添加键盘通知
        addKeyboardNotifiter()
        
        //点击闹钟回调
        self.clockView.clickButtonBlock = { [unowned self]
            (clickIndex:Int,selectDate:Date) in
            if clickIndex == 0 {
                self.textEditView.textView.becomeFirstResponder()
            }else{
                self.addNewTask(text: self.textEditView.textView.text, selectDate: selectDate)
                self.clockView.showClockView(isShow: false)
                self.overEdit()
                
            }
        }
        
        //添加搜索界面
        

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
        if result.count <= 0 {
            return
        }
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
        self.view.addSubview(effectView)
        self.view.bringSubview(toFront: self.wirteBtn)
        self.view.bringSubview(toFront: self.textEditView)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FocusModelViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK:Custom cell swipe Protocol
extension MainViewController: SwipeTableViewCellDelegate{
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .left {
            //删除任务
            let currentCell:MainTableViewCell = tableView.cellForRow(at: indexPath) as! MainTableViewCell
            currentCell.addDeleteLine()
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
        case .normal:
            visualEffectView()
            self.textEditView.textView.becomeFirstResponder()
            self.wirteBtn.btnType = .random
        case .random:
            self.textEditView.textView.text = "我是随机任务哦"
            self.wirteBtn.btnType = .clock
        case .clock:
            if self.textEditView.textView.isFirstResponder {
                self.textEditView.textView.resignFirstResponder()
                self.clockView.showClockView(isShow: true)
                self.view.bringSubview(toFront: self.clockView)
            }
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
        
        self.keyboardDuration = duration
        
        self.wirteBtn.animationChange(time: duration, isDown: false, addHeight: kbRect.height)
        
        let hasText:Bool = self.textEditView.textView.text.characters.count > 0
        
        self.wirteBtn.btnType = hasText ? .clock : .random
        
        
        self.textEditView.showPull(duration: duration)
        
        self.clockView.showClockView(isShow: false)

    }
    
    //键盘的隐藏
    @objc private func keyBoardWillHide(_ notification: Notification){
    }

}

//MARK: TextView delegate UIScrollViewDelegate
extension MainViewController:UITextViewDelegate,UIScrollViewDelegate{
    
    //MARK:UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if self.textEditView.textView.text.characters.count > 0{
                //有任务添加
                addNewTask(text: self.textEditView.textView.text, selectDate: nil)
            }
            overEdit()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        var totalText = self.textEditView.textView.text
        if (totalText?.characters.count)! > 0 {
            self.wirteBtn.btnType = .clock
        }else{
            self.wirteBtn.btnType = .random
            textEditView.textLine.isHidden = true
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if ((scrollView as? UITextView) != nil) {
            textEditView.showLine()
        }else{
            let offy = scrollView.contentOffset.y
            if offy < 0 {
                pullHeaderView?.setOffy = abs(scrollView.contentOffset.y)
            }
        }
        
    }
    
    
    fileprivate func overEdit() {
        self.textEditView.isHidden = true
        self.textEditView.textView.text = nil
        self.textEditView.textView.resignFirstResponder()
        self.wirteBtn.animationChange(time: keyboardDuration!, isDown: true, addHeight: 0)
        self.wirteBtn.btnType = .normal
        self.effectView.removeFromSuperview()
    }
    
    func addNewTask(text:String,selectDate:Date?) {
        dbugLog(message: "task:\(text), date:\(String(describing: selectDate))")
        let task = Task()
        task.textInfo = text
        if let endT = selectDate {
            task.endTime = endT
        }
        DBManager.insertTask(task: task)
        self.taskList.append(task)
        self.tableView.reloadData()
    }
}



