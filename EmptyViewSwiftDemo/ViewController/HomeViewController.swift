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
        for i in 0...2 {
            print("index =",i)
        }
    }

    override func initTableView() {
        super.initTableView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
            self.showNoDataStatusView()
        case 2:
            let vc = CollectionViewController.init()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource.object(at: indexPath.row) as? String
        return cell
    }

}

