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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        
        overList = OvewListViewController()
        overList.view.frame = CGRect(x: 0, y: (bottomView?.frame.maxY)!, width: kScreenWidth, height: kScreenHeight - (bottomView?.sizeH)! - 20)
        self.addChildViewController(overList)
        self.view.addSubview(overList.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showOverList(){
        UIView.animate(withDuration: animationTime, animations: {
            var bottomf:CGRect! = self.bottomView?.frame
            bottomf?.origin.y = 20.0
            self.bottomView?.frame = bottomf
            
            var overListViewf = self.overList.view.frame
            overListViewf.origin.y = (self.bottomView?.frame.maxY)!
            self.overList.view.frame = overListViewf
            
        }) { (flg) in
            
        }
    }
    
    //MARK:UITableViewDataSource,UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TaskTableViewCell = TaskTableViewCell(style: .default, reuseIdentifier: TaskTableViewCell.ReuseIdentifier)
        cell.textLabel?.text = "index"
        return cell
    }
    
    //MARK:UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y > 120+(myTableView?.contentSize.height)! - (myTableView?.sizeH)! {
            let time: TimeInterval = 0.2
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                self.showOverList()
            }

        }

    }
    
}
