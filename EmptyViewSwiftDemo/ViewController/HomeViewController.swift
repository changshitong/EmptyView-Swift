//
//  ViewController.swift
//  EmptyViewSwiftDemo
//
//  Created by changshitong on 2019/4/25.
//  Copyright © 2019 PLAN. All rights reserved.
//

import UIKit

class HomeViewController: PLCommonTableViewController {

    var dataSource:NSMutableArray = NSMutableArray.init(objects: "NormalVC","TableViewVC","CollectionViewVC")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Demo List"
        self.tableView .register(TableViewCell.self, forCellReuseIdentifier: "ev_cell")
    }

    override func initTableView() {
        super.initTableView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func showNoDataView() {
        self.emptyView.setImage(image: UIImage.init(named: "empty")!)
        self.emptyView.setTitle(title: "无内容")
        self.emptyView.setDetail(detail: "当前没有相关的内容，请先XXX")
        self.emptyView.setActionButtonTitle(title: "返回")
        self.emptyView.isHidden = false
        self.emptyView.superview?.bringSubviewToFront(self.emptyView)
    }
    
    override func emptyView(view: PLEmptyView, didSelectedActionButton: UIButton) {
        self.resetLoadStatus()
    }
    
    //MARK: - tableView delegate & dataSource
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let vc = NormalViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            self.showNoDataView()
        case 2:
            let vc = CollectionViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            return CGFloat(300)
        }
        return CGFloat(50)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ev_cell", for: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource.object(at: indexPath.row) as? String
        return cell
    }

}

