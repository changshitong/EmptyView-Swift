//
//  PLCommonCollectionViewController.swift
//  EmptyViewSwiftDemo
//
//  Created by changshitong on 2019/4/25.
//  Copyright © 2019 PLAN. All rights reserved.
//

import UIKit

protocol PLCommonCollectionViewControllerSubviews {
    
    var collectionViewFlowLayout:UICollectionViewFlowLayout { get }
    
    var collectionView:UICollectionView { get }
    
    func initCollectionViewFlowLayout()
    
    func initCollectionView()
    
    func layoutCollectionView()
    
}

class PLCommonCollectionViewController: PLCommonViewController,PLCommonCollectionViewControllerSubviews,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    open lazy private(set) var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        var flowLayout = UICollectionViewFlowLayout.init()
        return flowLayout
    }()
    
    open lazy private(set) var collectionView: UICollectionView = {
        var view = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: self.collectionViewFlowLayout)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.addObserver(self, forKeyPath: "contentInset", options: .new, context: nil)
        self.showNoDataStatusView()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath=="contentInset" {
            self.layoutEmptyView()
        }
    }
    
    override func initSubviews() {
        super .initSubviews()
        self .initCollectionViewFlowLayout()
        self.initCollectionView()
        self.layoutCollectionView()
    }
    
    func initCollectionViewFlowLayout() {
        self.collectionViewFlowLayout.scrollDirection = .vertical
    }
    
    func initCollectionView() {
        self.view.addSubview(self.collectionView)
    }
    
    func layoutCollectionView() {
        self.collectionView.frame = self.view.bounds
        self.collectionView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)
    }
    
    override func initEmptyView() {
        self.collectionView .addSubview(self.emptyView)
        self.emptyView.backgroundColor = .white
    }
    
    override func layoutEmptyView() {
        super.layoutEmptyView()
        
        var insets = self.collectionView.contentInset
        if #available(iOS 11.0, *) {
            if self.collectionView.contentInsetAdjustmentBehavior != .never {
                insets = self.collectionView.adjustedContentInset
            }
        }
        
        self.emptyView.frame = CGRect.init(x: 0, y: 0, width: self.collectionView.bounds.width - insets.left-insets.right, height: self.collectionView.bounds.height - insets.top-insets.bottom)
        
    }
    
    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        self.layoutEmptyView()
    }
    ///MARK:
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
