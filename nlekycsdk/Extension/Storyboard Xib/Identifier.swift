//
//  Identifier.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import Foundation
import UIKit

//
// MARK: - Identitifer protocol
protocol Identifier {
    
    // Static vartiable to get id of object
    static var identifier: String {get}
}

//
// MARK: - Exntension
extension Identifier {
    
    static var identifier: String {
        return String(describing: self)
    }
}


//
// MARK: - Conform automatically
extension UIViewController: Identifier {}
extension UIView: Identifier {}
