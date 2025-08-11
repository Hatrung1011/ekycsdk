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
    
    static var storyBoard: AppStoryboard {get set}
    
    // Get view controller from storyboard
    static var storyboardViewController: Element {get}
}

//
// MARK: - Extend StoryboardInitialization if Element is UIViewController
extension StoryboardInitialization where Element: UIViewController {
    
    // Get view controller
    static var storyboardViewController: Element {
        return storyBoard.instance.instantiateViewController(withIdentifier: Element.identifier) as! Element
    }
}

enum AppStoryboard : String {
    //Common storyboards
    case Main             = "Main"
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}
