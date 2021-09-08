//
//  PLEmptyView.swift
//  EmptyViewSwiftDemo
//
//  Created by changshitong on 2019/4/25.
//  Copyright © 2019 PLAN. All rights reserved.
//

import UIKit

// EmptyView Protocol
protocol PLEmptyViewDelegate {
    /* This method is called when the actionButton is clicked */
    func emptyView(view:PLEmptyView,didSelectedActionButton:UIButton)
}

// Base View
class PLEmptyView: UIView {
    
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
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    open lazy private(set) var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
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
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRect.zero)
    }
    
}

//MARK: - Base UI -

extension PLEmptyView {
    
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
            contentView.ev_setY(y: CGFloat(verticalOffset))
            scrollView.bounces = true
        } else {
            contentView.ev_setY(y: CGFloat(verticalOffset) + scrollView.bounds.midY - contentViewSize.height/2.0)
            scrollView.bounces = false
        }
        
        let scrollViewContentSizeWith = fmax(scrollView.frame.width - scrollView.contentInset.ev_width(), contentViewSize.width)
        let scrollViewContentSizeHeight = fmax(scrollView.frame.height - scrollView.contentInset.ev_height(), contentView.frame.maxY)
        scrollView.contentSize = CGSize.init(width: scrollViewContentSizeWith, height: scrollViewContentSizeHeight)
        
        var originY = CGFloat(0.0)
        if !imageView.isHidden {
           imageView.sizeToFit()
           imageView.frame = CGRect.init(x: imageInsets.left, y: imageInsets.top, width: imageView.frame.width, height: imageView.frame.height)
            imageView.center = CGPoint.init(x: contentView.frame.width/2.0, y: imageView.center.y)
            originY = imageView.frame.maxY + imageInsets.bottom
        }

        if !titleLabel.isHidden {
            titleLabel.frame = CGRect.init(x: titleInsets.left, y: originY + titleInsets.top, width: contentView.frame.width - titleInsets.ev_width(), height: titleLabel.frame.height)
            originY = titleLabel.frame.maxY + titleInsets.bottom;
            
        }
        
        if !detailLabel.isHidden {
            detailLabel.frame = CGRect.init(x: detailInsets.left, y: originY + detailInsets.top, width: contentView.frame.width - detailInsets.ev_width(), height: detailLabel.frame.height)
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
                actionButton.frame = CGRect.init(x:actionButtonInsets.left , y: originY + actionButtonInsets.top, width: contentView.frame.width - actionButtonInsets.ev_width(), height: actionButton.frame.height)
            }
            originY = actionButton.frame.maxY + actionButtonInsets.bottom;
            actionButton.clipsToBounds = self.actionButtonRoundCorners;
            if (self.actionButtonRoundCorners) {
                self.actionButton.layer.cornerRadius = self.actionButton.frame.height/2.0;
            }
        }
    }
    
    /// ContentView fitSize
    public func sizeOfContentViewFits() -> CGSize {
        var resultHeight = 0.0
        let resultWidth = self.scrollView.bounds.width + self.scrollView.contentInset.ev_width()
        
        if !imageView.isHidden {
            var imageViewHeight = imageView .sizeThatFits(CGSize.init(width: resultWidth-imageInsets.ev_width(), height: CGFloat.greatestFiniteMagnitude)).height
            imageView.ev_setHeight(height: imageViewHeight)
            imageViewHeight += imageInsets.ev_height()
            resultHeight += Double(imageViewHeight)
        }
        
        if !titleLabel.isHidden {
            var titleHeight = titleLabel.sizeThatFits(CGSize.init(width: resultWidth-titleInsets.ev_width(), height: CGFloat.greatestFiniteMagnitude)).height
            titleLabel.ev_setHeight(height: titleHeight)
            titleHeight += titleInsets.ev_height()
            resultHeight += Double(titleHeight)
        }
        
        if !detailLabel.isHidden {
            var detailHeight = detailLabel.sizeThatFits(CGSize.init(width: resultWidth-detailInsets.ev_width(), height: CGFloat.greatestFiniteMagnitude)).height
            detailLabel.ev_setHeight(height: detailHeight)
            detailHeight += detailInsets.ev_height()
            resultHeight += Double(detailHeight)
        }
        
        if !actionButton.isHidden {
            var buttonHeight = actionButton.sizeThatFits(CGSize.init(width: resultWidth-actionButtonInsets.ev_width(), height: CGFloat.greatestFiniteMagnitude)).height
            actionButton.ev_setHeight(height: buttonHeight)
            buttonHeight += actionButtonInsets.ev_height()
            resultHeight += Double(buttonHeight)
        }
        
        return CGSize.init(width: Double(resultWidth), height: resultHeight)
    }
    
}

//MARK: - Button Action -

extension PLEmptyView {
    
    /// actionButton touch
    @objc func actionButtonDidSelected(button:UIButton) {
        delegate?.emptyView(view: self, didSelectedActionButton: button)
    }
    
}

//MARK: - Set ViewStyle Func -

extension PLEmptyView {
    
   /*  Button Corners Setter */
    
   public var shouldActionButtonRoundCorners: Bool {
        get {
            return actionButtonRoundCorners
        }
        set {
            actionButtonRoundCorners = shouldActionButtonAutoFitWidth
            self.setNeedsLayout()
        }
    }
    
   /*  Content Offset Setter */
    
   public var contentVerticalOffset: CGFloat {
        get {
            return verticalOffset
        }
        set {
            verticalOffset = newValue
            self.setNeedsLayout()
        }
    }
    
    /* backgroundColor Setter */
    
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
    
    /* Font Setter */
    
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
    
    /* Content Setter */
    
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

//MARK: - Private Func -

fileprivate extension UIView {
    
    func ev_setX(x:CGFloat) {
        var rect = self.frame
        rect.origin.x = x
        self.frame = rect
    }
    
    func ev_setY(y:CGFloat) {
        var rect = self.frame
        rect.origin.y = y
        self.frame = rect
    }
    
    func ev_setWidth(width:CGFloat) {
        var rect = self.frame
        rect.size.width = width
        self.frame = rect
    }
    
    func ev_setHeight(height:CGFloat) {
        var rect = self.frame
        rect.size.height = height
        self.frame = rect
    }
}

fileprivate extension UIEdgeInsets {
    
    func ev_width() -> CGFloat {
        return self.left + self.right
    }
    
    func ev_height() -> CGFloat {
        return self.top + self.bottom
    }
    
}
