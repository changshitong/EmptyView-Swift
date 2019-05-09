//
//  PLCommonTableViewController.swift
//  EmptyViewSwiftDemo
//
//  Created by changshitong on 2019/4/25.
//  Copyright © 2019 PLAN. All rights reserved.
//

import UIKit

protocol PLCommonTableViewControllerSubviews {
    ///创建tableView：可重写修改tableView
    func initTableView()
    ///布局tableView：可重写修改tableView布局
    func layoutTableView()
}

class PLCommonTableViewController: PLCommonViewController,PLCommonTableViewControllerSubviews,UITableViewDelegate,UITableViewDataSource {
    
    public var tableViewStyle = UITableView.Style.grouped
    public lazy private(set) var tableView: UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: self.tableViewStyle)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
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
        self.tableView .addObserver(self, forKeyPath: "contentInset", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath=="contentInset" {
            self.layoutEmptyView()
        }
    }
    
    override func initSubviews() {
        super.initSubviews()
        self.initTableView()
        self.layoutTableView()
    }
    
    public func initTableView() {
        self.view.addSubview(self.tableView)
        self.emptyView.backgroundColor = UIColor.white
    }
    
    public func layoutTableView() {
        self.tableView.frame = self.view.bounds
        self.tableView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
    }
    
    override func initEmptyView() {
        super.initEmptyView()
        self.tableView.addSubview(self.emptyView)
    }
    
    override func layoutEmptyView() {
        super.layoutEmptyView()
        self.emptyView.frame = self.tableView.bounds
        
        var insets = self.tableView.contentInset
        if #available(iOS 11.0, *) {
            if self.tableView.contentInsetAdjustmentBehavior != .never {
                insets = self.tableView.adjustedContentInset
            }
        }
        
        if (self.tableView.tableHeaderView != nil) {
            self.emptyView.frame = CGRect.init(x: 0, y: self.tableView.tableHeaderView!.frame.maxY, width: self.tableView.bounds.width - insets.left - insets.right, height: self.tableView.bounds.height - insets.top - insets.bottom - self.tableView.tableHeaderView!.frame.maxY)
        } else {
            self.emptyView.frame = CGRect.init(x: 0, y: 0, width: self.tableView.bounds.width - insets.left-insets.right, height: self.tableView.bounds.height - insets.top-insets.bottom)
        }
        
    }
    
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        self.layoutEmptyView()
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

