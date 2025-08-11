//
//  ERTextField.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import UIKit
import FontAwesome_iOS

class ERTextField: UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCommon()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    func initCommon() {
        self.borderStyle = .none
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.neutralColor300.cgColor
        self.layer.cornerRadius = 8
    }
    
    func showAsErrorField() {
        self.layer.borderColor = UIColor.red.cgColor
    }
    
    func showAsNormalField() {
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        var newPadding = padding
        if let view = self.leftView {
            newPadding.left = view.bounds.width
        }
        if let view = self.rightView {
            newPadding.right = view.bounds.width
        }
        return bounds.inset(by: newPadding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        var newPadding = padding
        if let view = self.leftView {
            newPadding.left = view.bounds.width
        }
        if let view = self.rightView {
            newPadding.right = view.bounds.width
        }
        return bounds.inset(by: newPadding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        var newPadding = padding
        if let view = self.leftView {
            newPadding.left = view.bounds.width
        }
        if let view = self.rightView {
            newPadding.right = view.bounds.width
        }
        return bounds.inset(by: newPadding)
    }
    
    var dropdownData: [String]?
    
    func showAsDropDownField(data: [String]) {
        dropdownData = data
        let view = UIView.paddingViewWithFontawesomeImage(image: "fa-caret-down")
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDropDownAction)))
        self.rightViewMode = .always
        self.rightView = view
    }
    
    func showAsDatePicker(data: [String]) {
        dropdownData = data
        let view = UIView.paddingViewWithFontawesomeImage(image: "fa-calendar")
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDropDownAction)))
        self.rightViewMode = .always
        self.rightView = view
    }

    func showLeftView(icon: String ) {
        let rightView: UIView = UIView.paddingViewWithFontawesomeImage(image: icon)
        self.leftView = rightView
        self.leftViewMode = .always
    }
    
    func showAsSecurityField() {
        let rightView: UIView = UIView.paddingViewWithSystemImage(image: "eye.fill")
        rightView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleSecurityTextField)))
        self.rightView = rightView
        self.rightViewMode = .always
    }
    
    @objc func toggleSecurityTextField() {
        self.isSecureTextEntry = !self.isSecureTextEntry
        var imageName = "eye.fill"
//        let color = UIColor.gray
        let color = UIColor.neutralColor400
        if self.isSecureTextEntry {
            imageName = "eye.fill"
            
        }else {
            imageName = "eye.slash.fill"
        }
//        let img = UIImage(icon: imageName, backgroundColor: UIColor.clear, iconColor: color, andSize: CGSize(width: 20, height: 20))
        let img = UIImage(systemName: imageName)?.withTintColor(color)
        if let rightview = self.rightView {
            if let imageView = rightview.subviews.first as? UIImageView{
                imageView.image = img
            }
        }
    }
    
    @objc func handleDropDownAction() {
        let _ = self.delegate?.textFieldShouldBeginEditing?(self)
    }
    
}

extension UIView {
    class func paddingViewWithFontawesomeImage(image: String, padding: CGFloat = 15, imageSize: CGFloat = 20) -> UIView {
        let color = UIColor.lightGray
        
        let img = UIImage(icon: image, backgroundColor: UIColor.clear, iconColor: color, andSize: CGSize(width: 20, height: 20)) ?? UIImage()
        
        let imageHeight: CGFloat = imageSize
        let imageWidth: CGFloat = imageSize
        
        let viewHeight = imageHeight
        let viewWidth = imageHeight + padding
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
        imageView.contentMode = .scaleAspectFit
        
        imageView.image = img
        imageView.tintColor = UIColor.lightGray
        imageView.center = paddingView.center
        paddingView.addSubview(imageView)
        
        return paddingView
    }
    
    class func paddingViewWithSystemImage(image: String, padding: CGFloat = 15, imageSize: CGFloat = 20) -> UIView {
        let color = UIColor.neutralColor400
        
//        let img = UIImage(icon: image, backgroundColor: UIColor.clear, iconColor: color, andSize: CGSize(width: 20, height: 20)) ?? UIImage()
        let img = UIImage(systemName: image)?.withTintColor(color)
        
        let imageHeight: CGFloat = imageSize
        let imageWidth: CGFloat = imageSize
        
        let viewHeight = imageHeight
        let viewWidth = imageHeight + padding
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
        imageView.contentMode = .scaleAspectFit
        
        imageView.image = img
        imageView.tintColor = UIColor.lightGray
        imageView.center = paddingView.center
        paddingView.addSubview(imageView)
        
        return paddingView
    }
}
