//
//  PLCommonTableViewController.swift
//  EmptyViewSwiftDemo
//
//  Created by changshitong on 2019/4/25.
//  Copyright © 2019 PLAN. All rights reserved.
//

import UIKit

class PLCommonTableViewController: PLCommonViewController,UITableViewDelegate,UITableViewDataSource {
    
    public var tableViewStyle = UITableView.Style.grouped
    public var tableView: UITableView?
    
    override init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.view.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(style: UITableView.Style) {
        self.init()
        tableViewStyle = style
        print(#function,tableViewStyle.rawValue,"=",style.rawValue)
    }
    
    //MARK:- UI
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initSubviews() {
        super.initSubviews()
        self.initTableView()
        self.layoutTableView()
    }
    
    public func initTableView() {
        print(#function, tableViewStyle.rawValue)
        self.tableView = UITableView.init(frame: CGRect.zero, style: tableViewStyle)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.view.addSubview(self.tableView!)
    }
    
    public func layoutTableView() {
        self.tableView?.frame = self.view.bounds
        self.tableView?.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
    }
    
    //MARK: - TableView Delegate & DataSource
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }

}

