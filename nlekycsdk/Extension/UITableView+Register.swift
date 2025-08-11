//
//  UITableView+Register.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import Foundation
import UIKit


//
// MARK: - Register View
extension UITableView {
    func registerCell<T: XibInitialization>(_ viewType: T.Type) {
        self.register(viewType.xib(), forCellReuseIdentifier: viewType.identifier)
    }
}
