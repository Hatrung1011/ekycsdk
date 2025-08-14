//
//  StoryboardInitialization.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import Foundation
import UIKit

//
// MARK: - StoryboardInitialization
protocol StoryboardInitialization: Identifier {

    // Associated type: Must adopt Identifier
    associatedtype Element: Identifier

    static var storyBoard: AppStoryboard { get set }

    // Get view controller from storyboard
    static var storyboardViewController: Element { get }
}

//
// MARK: - Extend StoryboardInitialization if Element is UIViewController
extension StoryboardInitialization where Element: UIViewController {

    // Get view controller
    static var storyboardViewController: Element {
        return storyBoard.instance.instantiateViewController(withIdentifier: Element.identifier)
            as! Element
    }
}

//
// MARK: - AppStoryboard
enum AppStoryboard: String {
    //Common storyboards
    case Main = "Main"
    var instance: UIStoryboard {
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

        // Fallback to main bundle if framework bundle is still nil (should not happen if embedded correctly)
        if frameworkBundle == nil {
            frameworkBundle = Bundle.main
        }

        return UIStoryboard(name: self.rawValue, bundle: frameworkBundle)
    }
}
