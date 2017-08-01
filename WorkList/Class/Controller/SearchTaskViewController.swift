//
//  SearchTaskViewController.swift
//  WorkList
//
//  Created by zhanfeng on 2017/7/28.
//  Copyright © 2017年 lzf. All rights reserved.
//

import UIKit
import RealmSwift


class SearchTaskViewController: BaseViewController {
    
    var historyArray = [[Task]]()//历史完成任务数据
    var searchResultArray = [[Task]]()//搜索结果
    let pullHeaderView = PullHeaderView(direction: .down)
    fileprivate let DBManager = DataManager()//数据库
    var searchControl:UISearchController = UISearchController(searchResultsController: nil)
    var popCompletion:((Void)->Void)?

    fileprivate lazy var tableView:UITableView = {
        [unowned self] in
        let tbw = UITableView(frame: CGRect.zero, style: .grouped)
        tbw.backgroundColor = UIColor.purple
        tbw.delegate = self
        tbw.dataSource = self
        tbw.backgroundColor = UIColor.backColor
        tbw.tableFooterView = UIView()
        tbw.separatorStyle = .none
        tbw.register(MainTableViewCell.self, forCellReuseIdentifier: "cellID")
        self.view.addSubview(tbw)
        tbw.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        return tbw
        }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        tableView.reloadData()
        
        /* 添加上拉返回效果 */
        self.tableView.addSubview(pullHeaderView)
        
        //searchBar
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 64))
//        searchControl.delegate = self;
        searchControl.dimsBackgroundDuringPresentation = false
        searchControl.searchBar.placeholder = "搜索"
        searchControl.searchBar.frame = CGRect(x: 20, y: 20, width: kScreenWidth - 80, height: 30)
        searchControl.searchBar.backgroundColor = UIColor.clear
        searchControl.searchBar.backgroundImage = UIImage.init()
        searchControl.searchBar.layer.borderWidth = 1
        searchControl.searchBar.layer.borderColor = UIColor.subTextColor.cgColor
        headerView.addSubview(searchControl.searchBar)
        tableView.tableHeaderView = headerView
        
        let settingBtn = UIButton(type: .custom)
        settingBtn.setImage(UIImage.init(named: "setting.png"), for: .normal)
        settingBtn.addTarget(self, action: #selector(clickSetting(button:)), for: .touchUpInside)
        headerView.addSubview(settingBtn)
        settingBtn.snp.makeConstraints { (make) in
            make.left.equalTo(searchControl.searchBar.snp.right).offset(10)
            make.centerY.equalTo(searchControl.searchBar.snp.centerY)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        


        
        /* 加载数据了数据 */
        reloadDataBase()
        
        pullHeaderView.frame = CGRect(x: 0, y: tableView.contentSize.height, width: kScreenWidth, height: pullHeaderView.frame.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func addTableViewHeaderView() {
        
    }
    
    func clickSetting(button:UIButton) {
        let setting = SettingViewController(nibName: "SettingViewController", bundle: nil)
        self.present(setting, animated: true, completion: nil)
    }
    
     func reloadDataBase() {
        self.historyArray.removeAll()
        let result:Results<Task> = DBManager.queryAlllist()
        if result.count <= 0 {
            return
        }
        var filterDic = [String:[Task]]()
        
        var index = 0
        repeat {
            let item:Task = result[index]
            let key = item.creatTime.stringWithFormat(Format: .YMD)
            if filterDic[key] == nil {
                filterDic[key] = [item]
            }else{
                filterDic[key]?.append(item)
            }
            index += 1
        } while index < result.count
        
        if filterDic.count > 0 {
            filterDic.forEach({ (key:String,value:[Task]) in
                self.historyArray.append(value)
            })
        }
        tableView.reloadData()
        tableView.contentOffset = CGPoint(x: 0, y: 0)
    }
}

//MARK: TableViewDelegate Method
extension SearchTaskViewController:UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.historyArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MainTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellID") as! MainTableViewCell
        let task = self.historyArray[indexPath.section][indexPath.row]
        cell.task = task
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let task = self.historyArray[indexPath.section][indexPath.row] 
        return task.contentHeight(task: task)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let task:Task = self.historyArray[section].first!
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 20))
        headerView.backgroundColor = UIColor.backColor
        let label = UILabel(frame: CGRect(x: 25, y: 0, width: kScreenWidth, height: 20))
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = task.creatTime.stringWithFormat(Format: .YMD)
        label.textColor = UIColor.subTextColor
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.000001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    //scrollDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if ((scrollView as? UITextView) != nil) {
        }else{
            let offy = scrollView.contentOffset.y
            if offy > 0 {
                pullHeaderView.setOffy = offy
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if tableView.contentSize.height>kScreenHeight {
            if scrollView.contentOffset.y >= tableView.contentSize.height - kScreenHeight + 150 {
                self.hiddenSelfView()
            }
        }else{
            if scrollView.contentOffset.y > 150 {
                self.hiddenSelfView()
            }

        }

    }
    
    func hiddenSelfView() {
        
        if let popBlock = popCompletion {
            popBlock()
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: { 
            var selfFrame = self.view.frame
            selfFrame.origin.y = -kScreenHeight
            self.view.frame = selfFrame
            
        }, completion: nil)
    }

    
}

extension SearchTaskViewController:UISearchControllerDelegate{
    
}



