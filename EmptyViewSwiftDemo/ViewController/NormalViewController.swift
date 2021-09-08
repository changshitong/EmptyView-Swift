//
//  NormalViewController.swift
//  EmptyViewSwiftDemo
//
//  Created by changshitong on 2019/5/6.
//  Copyright © 2019 PLAN. All rights reserved.
//

import UIKit

class NormalViewController: PLCommonViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "viewController"
        self.showNoDataStatusView()
        self.emptyView.delegate = self
    }
    
    override func emptyView(view: PLEmptyView, didSelectedActionButton: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
