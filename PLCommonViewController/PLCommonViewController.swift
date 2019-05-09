//
//  PLCommonViewController.swift
//  EmptyViewSwiftDemo
//
//  Created by changshitong on 2019/4/25.
//  Copyright © 2019 PLAN. All rights reserved.
//

import UIKit

public enum ViewDataLoadStatus:NSString {
    ///闲置
    case idle = "idle"
    ///加载中
    case loading = "loading"
    ///加载完成：无数据
    case noData = "noData"
    ///加载完成：加载异常
    case exception = "exception"
    ///加载完成：没有更多数据
    case noMore = "noMore"
}

protocol PLCommonViewControllerLoadStatus {
    
    var loadStatus:ViewDataLoadStatus { get }
    
    ///设置加载状态
    func setLoadStauts(status:ViewDataLoadStatus)
    
    func showLoadingStatusView()
    func showNoDataStatusView()
    func showExceptionStatusView()
    
    ///还原加载状态：闲置状态
    func resetLoadStatus()
    
}

class PLCommonViewController: UIViewController,PLEmptyViewDelegate {
    
    public lazy private(set) var emptyView: PLEmptyView = {
        let view = PLEmptyView.init()
        view.delegate = self
        view.isHidden = true
        return view
    }()
    
    public private(set) var loadStatus = ViewDataLoadStatus.idle
    
    
    init() {
        super.init(nibName: nil, bundle: nil);
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    // MARK - UI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initSubviews()
    }
    
    open func initSubviews() {
        self.view.backgroundColor = UIColor.white;
        self .initEmptyView()
    }
    
    open func initEmptyView() {
        self.view.addSubview(self.emptyView)
        self.emptyView.frame = self.view.bounds
        self.emptyView.autoresizingMask = UIView.AutoresizingMask(arrayLiteral: UIView.AutoresizingMask.flexibleHeight,UIView.AutoresizingMask.flexibleWidth)
    }
    
    open func emptyView(view: PLEmptyView, didSelectedActionButton: UIButton) {
        self.loadData()
        print("touch actionButton")
    }
    
    open func loadData() {}
    open func loadMoreData() {}
}

extension PLCommonViewController: PLCommonViewControllerLoadStatus {
    
    func setLoadStauts(status: ViewDataLoadStatus) {
        switch status {
        case .exception:
            self.showExceptionStatusView()
        case .loading:
            self.showLoadingStatusView()
        case .noData:
            self.showNoDataStatusView()
        default:
            self.resetLoadStatus()
        }
    }
    
    func showLoadingStatusView() {
        
    }
    
    func showNoDataStatusView() {
        self.emptyView.setImage(image: UIImage.init(named: "empty")!)
        self.emptyView.setTitle(title: "无内容")
        self.emptyView.setDetail(detail: "当前没有相关的内容，请先XXX")
        self.emptyView.setActionButtonTitle(title: "明白了")
        self.emptyView.isHidden = false
    }
    
    func showExceptionStatusView() {
        self.emptyView.setImage(image: UIImage.init(named: "empty")!)
        self.emptyView.setTitle(title: "获取失败")
        self.emptyView.setDetail(detail: "网络连接不稳定，请稍后重试")
        self.emptyView.setActionButtonTitle(title: "刷新")
        self.emptyView.isHidden = false
    }
    
    func resetLoadStatus() {
        self.emptyView.isHidden = true
        self.loadStatus = .idle
    }
}



