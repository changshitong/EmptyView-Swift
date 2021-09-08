//
//  TableViewCell.swift
//  EmptyViewSwiftDemo
//
//  Created by chang on 2021/9/8.
//  Copyright © 2021 PLAN. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    lazy var emptyView:PLEmptyView = {
        let view = PLEmptyView.init()
        view.setImage(image: UIImage.init(named: "empty"))
        view.setTitle(title: "这是一个空Cell")
        view.setDetail(detail: "某些情况下需要设置列表的某个cell为空")
        return view
    } ()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI () {
        self.emptyView.frame = self.contentView.bounds;
        self.emptyView.autoresizingMask = [AutoresizingMask.flexibleHeight,AutoresizingMask.flexibleWidth]
        self.contentView.addSubview(self.emptyView)
    }

}
