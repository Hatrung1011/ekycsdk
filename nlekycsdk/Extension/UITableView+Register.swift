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
        // Find the correct framework bundle
        var frameworkBundle: Bundle?

        // Attempt 1: Use Bundle(for: Class.self)
        frameworkBundle = Bundle(for: NLeKYCSdk.self)

        // If Bundle(for: Class.self) returns the main bundle, try to find the framework bundle manually
        if frameworkBundle?.bundleIdentifier == Bundle.main.bundleIdentifier {
            // Try to find the framework bundle in the app's Frameworks directory
            if let frameworksPath = Bundle.main.path(forResource: "Frameworks", ofType: nil) {
                let frameworkPath = frameworksPath + "/nlekycsdk.framework"
                frameworkBundle = Bundle(path: frameworkPath)
            }

            // If still not found, try alternative path
            if frameworkBundle == nil {
                if let frameworkPath = Bundle.main.path(
                    forResource: "nlekycsdk", ofType: "framework")
                {
                    frameworkBundle = Bundle(path: frameworkPath)
                }
            }
        }

        // Fallback to main bundle if framework bundle is still nil
        if frameworkBundle == nil {
            frameworkBundle = Bundle.main
        }

        let nib = UINib(nibName: viewType.identifier, bundle: frameworkBundle)
        self.register(nib, forCellReuseIdentifier: viewType.identifier)
    }
}
