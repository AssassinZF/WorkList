//
//  OvewListViewController.swift
//  WorkList
//
//  Created by Daisy on 2017/7/16.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit

class OvewListViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{
    
    var myTableView:UITableView?
    var dataList = [Task]()
    var oldFrame:CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        
        myTableView = UITableView(frame: self.view.frame, style: .grouped)
        myTableView?.backgroundColor = UIColor.white
        myTableView?.dataSource = self
        myTableView?.delegate = self
        self.view.addSubview(myTableView!)
        myTableView?.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.ReuseIdentifier)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TaskTableViewCell = TaskTableViewCell(style: .default, reuseIdentifier: TaskTableViewCell.ReuseIdentifier)
        cell.textLabel?.text = "index"
        return cell
    }
    
    func hiddenListView(){
        UIView.animate(withDuration: animationTime) {
            self.view.frame = self.oldFrame!
            let inputView = self.view.superview?.viewWithTag(inputTag)
            inputView?.frame = CGRect(x: 0, y: kScreenHeight - KIputHeight, width: kScreenWidth, height: KIputHeight)
        }
    }
    
    //MARK:UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y < -120 {
            let time: TimeInterval = 0.2
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                self.hiddenListView()
            }
            
        }
        
    }

    

}
