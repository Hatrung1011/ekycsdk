//
//  AVCaptureVideoOrientation.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import Foundation
import AVFoundation
import UIKit

extension AVCaptureVideoOrientation {
    internal init(orientation: UIInterfaceOrientation) {
        switch orientation {
        case .portrait:
            self = .portrait
        case .portraitUpsideDown:
            self = .portraitUpsideDown
        case .landscapeLeft:
            self = .landscapeLeft
        case .landscapeRight:
            self = .landscapeRight
        default:
            self = .portrait
        }
    }
}
