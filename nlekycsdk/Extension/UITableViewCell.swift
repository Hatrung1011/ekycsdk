//
//  UITableViewCell.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import UIKit

extension UITableViewCell {
    struct CellConfiguration {
        var text: String?
        var secondaryText: String?
        var textFont: UIFont?
        var textColor: UIColor?
        var secondaryTextFont: UIFont?
        var secondaryTextColor: UIColor?
        var attributeText: NSAttributedString?
        var secondaryAttributeText: NSAttributedString?
        var image: UIImage?
        var didSelectIndex: ((_ index: IndexPath) -> Void)?
        var imageTintColor: UIColor?
        var cellID: String?
        var id: String?
    }
    
    func setup(config data: CellConfiguration) {
        if #available(iOS 14.0, *) {
            var config = self.defaultContentConfiguration()
            
            if let image = data.image {
                config.image = image
            }
            if let text = data.text {
                config.text = text
            }
            if let secondaryText = data.secondaryText {
                config.secondaryText = secondaryText
            }
            if let font = data.textFont {
                config.textProperties.font = font
            }
            if let color = data.textColor {
                config.textProperties.color = color
            }
            if let secondaryFont = data.secondaryTextFont {
                config.secondaryTextProperties.font = secondaryFont
            }
            if let secondaryColor = data.secondaryTextColor {
                config.secondaryTextProperties.color = secondaryColor
            }
            config.textProperties.numberOfLines = 0
            config.secondaryTextProperties.numberOfLines = 0
            config.attributedText = data.attributeText
            config.secondaryAttributedText = data.secondaryAttributeText
            config.prefersSideBySideTextAndSecondaryText = true
            config.textToSecondaryTextVerticalPadding = 5
            config.imageToTextPadding = 16
            config.textToSecondaryTextHorizontalPadding = 5
            config.imageProperties.tintColor = data.imageTintColor
            self.contentConfiguration = config
        } else {
            self.textLabel?.text = data.text
            self.textLabel?.attributedText = data.attributeText
            self.textLabel?.font = data.textFont
            self.textLabel?.textColor = data.textColor
            self.detailTextLabel?.text = data.secondaryText
            self.detailTextLabel?.textColor = data.secondaryTextColor
            self.detailTextLabel?.font = data.secondaryTextFont
            self.detailTextLabel?.attributedText = data.secondaryAttributeText
            self.imageView?.image = data.image
            self.textLabel?.numberOfLines = 0
            self.detailTextLabel?.numberOfLines = 0
            self.imageView?.tintColor = data.imageTintColor
        }
    }
}
