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

        return UINib(nibName: Element.identifier, bundle: frameworkBundle)
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

        return Element(nibName: Element.identifier, bundle: frameworkBundle)
    }

}
