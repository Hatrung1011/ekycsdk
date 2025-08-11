//
//  XibInitialization.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import Foundation
import UIKit

//
// MARK: - XibInitialization
// Helper protocol to get xib generic
protocol XibInitialization: Identifier {
    
    associatedtype Element: Identifier
    
    static func xib() -> UINib
    
    static func xibInstance() -> Element
}

//
// MARK: - Default
extension XibInitialization {
    
    static func xib() -> UINib {
        return UINib(nibName: Element.identifier, bundle: nil)
    }
}

//
// MARK: - Extend UIView
extension XibInitialization where Element: UIView {
    
    static func xibInstance() -> Element {
        let xib = self.xib()
        return xib.instantiate(withOwner: self, options: nil).first! as! Element
    }
}

//
// MARK: - Extend UIViewController
extension XibInitialization where Element: UIViewController {
    
    static func xibInstance() -> Element {
        return Element(nibName: Element.identifier, bundle: nil)
    }
    
}
