//
//  Constant.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import UIKit

struct Constants {

    static let isMasterApp = false
    static let kRealmSchemaVersion: UInt64 = 33
    // APPLICATION
    struct App {

        // Main
        static let isDebugJSON = true
        static let isHTTPS = true

        // Base
        static let BaseURL: String = {
            if Constants.App.isHTTPS {
                return "https://"
            } else {
                return "http://"
            }
        }()

        // Key
        struct Key {
            static let lbsPush: String = "NOTIFI_LBS"
            static let gpsPush: String = "NOTIFI_GPS"

            struct FirebaseKey {
                static let message: String = "MESSAGE"
                static let pushAction: String = "PUSH_ACTION"
                static let roleChanged: String = "ROLE_CHANGED"
                static let resetSync: String = "RESET_SYNC_TIME"
            }

            static let BaseAPIURL: String = {
                let infoKeys = Bundle.main.infoDictionary
                return infoKeys?["VNID_CONSENT_URL"] as! String
            }()
            static let BaseSocketURL = ""
            static let googleAPIKey = ""
        }
    }

    //
    // MARK: - Alert
    struct Alert {
        static func showErrorAlert(_ viewController: UIViewController, message: String?) {
            showAlert(viewController, title: "Lỗi", message: message)
        }

        static func showAlert(
            _ viewController: UIViewController, title: String?, message: String?, ok: String? = nil,
            cancel: String? = nil, cancelColor: UIColor = UIColor.systemGray,
            onCancel: (() -> Void)? = nil, onDone: (() -> Void)? = nil
        ) {
            let alert = NewYorkAlertController(title: title, message: message, style: .alert)
            alert.isTapDismissalEnabled = false

            if let text = cancel {
                let btn = NewYorkButton(title: text, style: .destructive) { _ in
                    onCancel?()
                }
                btn.setTitleColor(cancelColor, for: .normal)
                alert.addButton(btn)
            }
            if let text = ok {
                let btn = NewYorkButton(title: text, style: .default) { _ in
                    onDone?()
                }
                alert.addButton(btn)
            }

            if alert.isButtonsEmpty() {
                let btn = NewYorkButton(title: "OK", style: .default) { _ in
                    onDone?()
                }
                alert.addButton(btn)
            }
            viewController.present(alert, animated: true)
        }
    }

    //MARK:- User
    struct UserConfig {
        static var appType: String {
            get {
                return UserDefaults.standard.string(forKey: "kappType") ?? ""
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "kappType")
                UserDefaults.standard.synchronize()
            }
        }

        static var registeredUUID: String {
            get {
                return UserDefaults.standard.string(forKey: "kregisteredUUID") ?? ""
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "kregisteredUUID")
                UserDefaults.standard.synchronize()
            }
        }

        static var username: String {
            get {
                return UserDefaults.standard.string(forKey: "kusername") ?? ""
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "kusername")
                UserDefaults.standard.synchronize()
            }
        }

        static var hasLaunchedBefore: Bool {
            get {
                return UserDefaults.standard.bool(forKey: "khasLaunchedBefore")
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "khasLaunchedBefore")
                UserDefaults.standard.synchronize()
            }
        }

        static var isNoDisplayLivenessInstruction: Bool {
            get {
                return UserDefaults.standard.bool(forKey: "isNoDisplayInstruction")
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "isNoDisplayInstruction")
            }
        }
        static var isNoDisplayAppInstruction: Bool {
            get {
                return UserDefaults.standard.bool(forKey: "isNoDisplayAppInstruction")
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "isNoDisplayAppInstruction")
            }
        }
        static var isNoDisplayVCQRInstruction: Bool {
            get {
                return UserDefaults.standard.bool(forKey: "isNoDisplayVCQRInstruction")
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "isNoDisplayVCQRInstruction")
            }
        }
        static var isNoDisplayVCScanQRInstruction: Bool {
            get {
                return UserDefaults.standard.bool(forKey: "isNoDisplayVCScanQRInstruction")
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "isNoDisplayVCScanQRInstruction")
            }
        }
        static var isNoDisplayHomeInstruction: Bool {
            get {
                return UserDefaults.standard.bool(forKey: "isNoDisplayHomeInstruction")
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "isNoDisplayHomeInstruction")
            }
        }
    }

    struct Notifies {
        static let selectedMenuHasChanged = Notification.Name("selectedMenuHasChanged")
    }

    struct AppConfig {
        static let term = "https://ndakey.vn/20250109_TaC_NDA_KEY.pdf"
        //        static let term = "https://cdn.eidas.vn/publicfiles/ĐK&ĐK_Quản_lý_danh_tính_số_trên_ứng_dụng_NDA.pdf".addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        static let introductionVideo = "https://s3-sgn10.fptcloud.com/nda/ndakey/ndakey-intro.mp4"
    }
}

extension Thread {
    class func printCurrent() {
        debugPrint(
            "\r⚡️: \(Thread.current)"
                + "🏭: \(OperationQueue.current?.underlyingQueue?.label ?? "None")\r")
    }
}

// MARK: - UIImage Extension for Framework Bundle
extension UIImage {
    static func frameworkImage(named name: String) -> UIImage? {
        // Get the framework bundle using the same logic as other extensions
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
                let frameworkPath = Bundle.main.bundlePath + "/Frameworks/nlekycsdk.framework"
                frameworkBundle = Bundle(path: frameworkPath)
            }
        }

        // Fallback to main bundle if framework bundle is still nil
        if frameworkBundle == nil {
            frameworkBundle = Bundle.main
        }

        return UIImage(named: name, in: frameworkBundle, compatibleWith: nil)
    }
}
