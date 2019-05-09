//
//  PLEmptyView.swift
//  EmptyViewSwiftDemo
//
//  Created by changshitong on 2019/4/25.
//  Copyright © 2019 PLAN. All rights reserved.
//

import UIKit

///空白页的控件
protocol PLEmptyViewSubviews {
    
    var imageView:UIImageView { get }
    
    var titleLabel:UILabel { get }
    
    var detailLabel:UILabel { get }
    
    var actionButton: UIButton { get }
    
}

///设置空白页样式
protocol PLEmptyViewStyle {
    
    ///内容竖向偏移量
    var contentVerticalOffset:CGFloat {get set}
    
    ///动作按钮是否圆角
    var shouldActionButtonRoundCorners:Bool {get set}
    
    ///MARK: 设置文本颜色
    func setTitleColor(color:UIColor)
    func setDetailColor(color:UIColor)
    func setActionButtonTitleColor(color:UIColor)
    
    ///MARK: 设置文本字体
    func setTitleFont(font:UIFont)
    func setDetailFont(font:UIFont)
    func setActionButtonTitleFont(font:UIFont)
    
    ///MARK: 设置控件背景色
    func setActionButtonBackgroundColor(color:UIColor)
    
    ///MARK: 设置内容
    func setImage(image:UIImage?)
    func setTitle(title:String?)
    func setDetail(detail:String?)
    func setActionButtonTitle(title:String?)
    
}

protocol PLEmptyViewDelegate {
    func emptyView(view:PLEmptyView,didSelectedActionButton:UIButton)
}

class PLEmptyView: UIView,PLEmptyViewSubviews {
    
    public var delegate:PLEmptyViewDelegate?
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView.init()
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView.init()
        return view
    }()
    
    open lazy private(set) var imageView: UIImageView = {
        let view = UIImageView.init()
        view.isHidden = true
        return view
    }()
    
    open lazy private(set) var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    open lazy private(set) var detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    open lazy private(set) var actionButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.black
        button.isHidden = true
        button.contentEdgeInsets = UIEdgeInsets.init(top: 8, left: 40, bottom: 8, right: 40)
        button.addTarget(self, action: #selector(actionButtonDidSelected(button:)), for: .touchUpInside)
        return button
    }()
    
    ///内容竖向偏移量
    private var verticalOffset = CGFloat(0.0)
    
    ///button是否圆角：默认圆角
    private var actionButtonRoundCorners = true
    ///内容四周间隔
    open var imageInsets = UIEdgeInsets.zero
    open var titleInsets = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0)
    open var detailInsets = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0)
    open var shouldActionButtonAutoFitWidth = true
    open var actionButtonInsets = UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0)
    ///文本字体
    open var titleFont:UIFont?
    open var detailFont = UIFont.systemFont(ofSize: 12)
    open var actionTitleFont = UIFont.systemFont(ofSize: 15)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(frame: CGRect.zero)
    }
    
    //MARK: UI
    
    public func initSubviews() {
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.detailLabel)
        self.contentView.addSubview(self.actionButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.frame = self.bounds
        
        let contentViewSize = self.sizeOfContentViewFits()
        
        contentView.frame = CGRect.init(x: 0, y: 0, width: contentViewSize.width, height: contentViewSize.height)
        if contentView.bounds.height > scrollView.bounds.height {
            contentView.setY(y: CGFloat(verticalOffset))
            scrollView.bounces = true
        } else {
            contentView.setY(y: CGFloat(verticalOffset) + scrollView.bounds.midY - contentViewSize.height/2.0)
            scrollView.bounces = false
        }
        
        let scrollViewContentSizeWith = fmax(scrollView.frame.width - scrollView.contentInset.width(), contentViewSize.width)
        let scrollViewContentSizeHeight = fmax(scrollView.frame.height - scrollView.contentInset.height(), contentView.frame.maxY)
        scrollView.contentSize = CGSize.init(width: scrollViewContentSizeWith, height: scrollViewContentSizeHeight)
        
        var originY = CGFloat(0.0)
        if !imageView.isHidden {
           imageView.sizeToFit()
           imageView.frame = CGRect.init(x: imageInsets.left, y: imageInsets.top, width: imageView.frame.width, height: imageView.frame.height)
            imageView.center = CGPoint.init(x: contentView.frame.width/2.0, y: imageView.center.y)
            originY = imageView.frame.maxY + imageInsets.bottom
        }

        if !titleLabel.isHidden {
            titleLabel.frame = CGRect.init(x: titleInsets.left, y: originY + titleInsets.top, width: contentView.frame.width - titleInsets.width(), height: titleLabel.frame.height)
            originY = titleLabel.frame.maxY + titleInsets.bottom;
            
        }
        
        if !detailLabel.isHidden {
            detailLabel.frame = CGRect.init(x: detailInsets.left, y: originY + detailInsets.top, width: contentView.frame.width - detailInsets.width(), height: detailLabel.frame.height)
            originY = detailLabel.frame.maxY + detailInsets.bottom;
        }
        
        if !actionButton.isHidden {
            actionButton.sizeToFit()
            if shouldActionButtonAutoFitWidth {
                var rect = actionButton.frame
                rect.origin.y = originY + actionButtonInsets.top
                rect.size.width = CGFloat(fminf(Float(rect.width), Float(contentView.frame.width)))
                actionButton.frame = rect
                actionButton.center = CGPoint.init(x: contentView.frame.width/2.0, y: actionButton.center.y)
            } else {
                actionButton.frame = CGRect.init(x:actionButtonInsets.left , y: originY + actionButtonInsets.top, width: contentView.frame.width - actionButtonInsets.width(), height: actionButton.frame.height)
            }
            originY = actionButton.frame.maxY + actionButtonInsets.bottom;
            actionButton.clipsToBounds = self.actionButtonRoundCorners;
            if (self.actionButtonRoundCorners) {
                self.actionButton.layer.cornerRadius = self.actionButton.frame.height/2.0;
            }
        }
    }
    
    //MARK: Button Action
    
    @objc func actionButtonDidSelected(button:UIButton) {
        delegate?.emptyView(view: self, didSelectedActionButton: button)
    }
    
    //MARK: ContentView fitSize
    
    public func sizeOfContentViewFits() -> CGSize {
        var resultHeight = 0.0
        let resultWidth = self.scrollView.bounds.width + self.scrollView.contentInset.width()
        
        if !imageView.isHidden {
            var imageViewHeight = imageView .sizeThatFits(CGSize.init(width: resultWidth-imageInsets.width(), height: CGFloat.greatestFiniteMagnitude)).height
            imageView.setHeight(height: imageViewHeight)
            imageViewHeight += imageInsets.height()
            resultHeight += Double(imageViewHeight)
        }
        
        if !titleLabel.isHidden {
            var titleHeight = titleLabel.sizeThatFits(CGSize.init(width: resultWidth-titleInsets.width(), height: CGFloat.greatestFiniteMagnitude)).height
            titleLabel.setHeight(height: titleHeight)
            titleHeight += titleInsets.height()
            resultHeight += Double(titleHeight)
        }
        
        if !detailLabel.isHidden {
            var detailHeight = detailLabel.sizeThatFits(CGSize.init(width: resultWidth-detailInsets.width(), height: CGFloat.greatestFiniteMagnitude)).height
            detailLabel.setHeight(height: detailHeight)
            detailHeight += detailInsets.height()
            resultHeight += Double(detailHeight)
        }
        
        if !actionButton.isHidden {
            var buttonHeight = actionButton.sizeThatFits(CGSize.init(width: resultWidth-actionButtonInsets.width(), height: CGFloat.greatestFiniteMagnitude)).height
            actionButton.setHeight(height: buttonHeight)
            buttonHeight += actionButtonInsets.height()
            resultHeight += Double(buttonHeight)
        }
        
        return CGSize.init(width: Double(resultWidth), height: resultHeight)
    }
    
}

extension PLEmptyView:PLEmptyViewStyle {
    
    ///  Button Corners Setter
    
   public var shouldActionButtonRoundCorners: Bool {
        get {
            return actionButtonRoundCorners
        }
        set {
            actionButtonRoundCorners = shouldActionButtonAutoFitWidth
            self.setNeedsLayout()
        }
    }
    
    ///  Content Offset Setter
    
   public var contentVerticalOffset: CGFloat {
        get {
            return verticalOffset
        }
        set {
            verticalOffset = newValue
            self.setNeedsLayout()
        }
    }
    
    /// backgroundColor Setter
    
    public func setActionButtonBackgroundColor(color:UIColor) {
        self.actionButton.backgroundColor = color
    }
    
    /// TextColor Setter
    
    public func setTitleColor(color:UIColor) {
        self.titleLabel.textColor = color
    }
    
    public func setDetailColor(color:UIColor) {
        self.detailLabel.textColor = color
    }
    
    public func setActionButtonTitleColor(color:UIColor) {
        self.actionButton.setTitleColor(color, for: .normal)
    }
    
    /// Font Setter
    
    public func setTitleFont(font:UIFont) {
        self.titleLabel.font = font
        self.setNeedsLayout()
    }
    
    public func setDetailFont(font:UIFont) {
        self.detailLabel.font = font
        self.setNeedsLayout()
    }
    
    public func setActionButtonTitleFont(font: UIFont) {
        self.actionButton.titleLabel?.font = font
        self.setNeedsLayout()
    }
    
    /// Content Setter
    
    func setImage(image: UIImage?) {
        self.imageView.image = image
        self.imageView.backgroundColor = UIColor.red
        self.imageView.isHidden = (image == nil)
        self.setNeedsLayout()
    }
    
    func setTitle(title: String?) {
        self.titleLabel.text = title
        self.titleLabel.isHidden = title?.count == 0
        self .setNeedsLayout()
    }
    
    func setDetail(detail: String?) {
        self.detailLabel.text = detail
        self.detailLabel.isHidden = detail?.count == 0
        self.setNeedsLayout()
    }
    
    func setActionButtonTitle(title: String?) {
        self.actionButton.setTitle(title, for: .normal)
        self.actionButton.isHidden = title?.count == 0
        self.setNeedsLayout()
    }
    
}

fileprivate extension UIView {
    
    func setX(x:CGFloat) {
        var rect = self.frame
        rect.origin.x = x
        self.frame = rect
    }
    
    func setY(y:CGFloat) {
        var rect = self.frame
        rect.origin.y = y
        self.frame = rect
    }
    
    func setWidth(width:CGFloat) {
        var rect = self.frame
        rect.size.width = width
        self.frame = rect
    }
    
    func setHeight(height:CGFloat) {
        var rect = self.frame
        rect.size.height = height
        self.frame = rect
    }
}

fileprivate extension UIEdgeInsets {
    
    func width() -> CGFloat {
        return self.left + self.right
    }
    
    func height() -> CGFloat {
        return self.top + self.bottom
    }
    
}
