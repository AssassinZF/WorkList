//
//  MainViewController.swift
//  WorkList
//
//  Created by Daisy on 2017/7/15.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit

let animationTime:TimeInterval = 0.5

class MainViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    
    var myTableView:UITableView?
    var dataSource = [Task]()
    var bottomView:InputView?
    var overList:OvewListViewController!
    let dataManager = DataManager()
    var datePick:DatePickView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        readAllTask()
    }
    
    func setupUI(){
        let frame = CGRect(x: 0, y: 20, width: kScreenWidth, height: kScreenHeight - 44 - 20)
        myTableView = UITableView(frame: frame, style: .plain)
        myTableView?.dataSource = self
        myTableView?.delegate = self
        myTableView?.backgroundColor = UIColor.clear
        myTableView?.tableFooterView = UIView()
        myTableView?.backgroundView = WeaterView()
        self.view.addSubview(myTableView!)
        myTableView?.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.ReuseIdentifier)
        bottomView = InputView(frame: CGRect.zero)
        self.view.addSubview(bottomView!)
        
        bottomView?.textFinish = {
            (text:String)->Void in
            if text.characters.count > 0 {
            }
            
        }
        
        overList = OvewListViewController()
        overList.view.frame = CGRect(x: 0, y: (bottomView?.frame.maxY)!, width: kScreenWidth, height: kScreenHeight - (bottomView?.sizeH)! - 20)
        overList.oldFrame = overList.view.frame
        self.addChildViewController(overList)
        self.view.addSubview(overList.view)
        
        //NotificationCenter
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:读取所有任务列表
    func readAllTask() {
        let lists = dataManager.queryAlllist()
        dataSource.removeAll()
        for index in 0..<lists.count{
            dataSource.append(lists[index])
        }
        self.myTableView?.reloadData()
    }
    

    //MARK:add task
    func addTask(taskInfo:String,endTime:Date?) -> Void {
        let task = Task()
        task.taskInfo = taskInfo
        if let time = endTime {
            task.endTime = time
        }
        
        dataManager.insertTask(task: task)
        
    }

    //MARK:keyboard notification
    func keyBoardWillShow(_notification: Notification){
        keyboardChange(_notification: _notification)
    }
    
    func keyBoardWillHide(_notification: Notification){
        keyboardChange(_notification: _notification)
    }
    
    func keyboardChange(_notification:Notification) {
        //获取userInfo
        let kbInfo = _notification.userInfo
        //获取键盘的size
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //键盘的y偏移量
        let changeY = kbRect.origin.y - KIputHeight
        //键盘弹出的时间
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as!Double
        
        self.changeTextFiledWithAnimation(offy: changeY, duration: duration)

    }

    //MARK:改变textfieldframe
    func changeTextFiledWithAnimation(offy:CGFloat,duration:TimeInterval = animationTime) {
        
        UIView.animate(withDuration: duration, animations: { 
            var frame = self.bottomView?.frame
            frame?.origin.y = offy
            self.bottomView?.frame = frame!
            
            if offy == 20.0{
                var overListViewf = self.overList.view.frame
                overListViewf.origin.y = (self.bottomView?.frame.maxY)!
                self.overList.view.frame = overListViewf
            }
        }) { (fla:Bool) in
            
        }
    }
    
    //MARK:UITableViewDataSource,UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TaskTableViewCell = TaskTableViewCell(style: .default, reuseIdentifier: TaskTableViewCell.ReuseIdentifier)
        let task:Task = self.dataSource[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.text = task.taskInfo
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    //MARK:UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        
        var off:CGFloat = 0.0
        let f1 = myTableView?.contentSize.height
        let f2 = myTableView?.sizeH
        
        if Double(f1!) > Double(f2!) {
            off = (myTableView?.contentSize.height)! - (myTableView?.sizeH)!
        }else{
            off = (myTableView?.contentSize.height)!
        }
        
        let flg = scrollView.contentOffset.y > 120+off
        let isDown = scrollView.contentOffset.y > 0
        if  flg && isDown{
            let time: TimeInterval = 0.2
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                self.changeTextFiledWithAnimation(offy: 20)
            }

        }

    }
    
}
