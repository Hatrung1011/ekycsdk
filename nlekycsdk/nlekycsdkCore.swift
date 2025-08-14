//
//  nlekycsdk.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import Combine
import FlashLiveness
import IDCardReader
import UIKit

// MARK: - Main Framework Class
public class NLeKYCSdk: NSObject {
    public static let shared = NLeKYCSdk()
    private override init() {
        super.init()
    }
}

public class NLeKYCSdkManager: UIViewController {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()

    static let shared = NLeKYCSdkManager()

    // Config values - sẽ được set sau khi API call thành công
    private var privateKey = ""
    private var publicKey = ""
    private var appId = ""
    private var ekycUrl = ""

    // Callback for demo app
    public typealias EkycCallback = (String) -> Void
    private var ekycCallback: EkycCallback?

    public func initSDK() {
        setupIDCardReader()
    }

    // MARK: - Public Methods
    public func scanMRZ(callback: EkycCallback? = nil) {
        // Store callback for later use
        self.ekycCallback = callback

        let vc = EkycInstructionViewController.storyboardViewController
        // Pass callback to view controller
        vc.ekycCallback = callback

        // Find the root view controller using the modern approach
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let rootViewController = windowScene.windows.first?.rootViewController
        {
            // Try to find navigation controller in the hierarchy
            if let navigationController = rootViewController as? UINavigationController {
                // Root is a navigation controller
                navigationController.pushViewController(vc, animated: true)
            } else if let navigationController = rootViewController.navigationController {
                // Root has a navigation controller
                navigationController.pushViewController(vc, animated: true)
            } else {
                // No navigation controller found, create one and present it
                let navigationController = UINavigationController(rootViewController: vc)
                navigationController.modalPresentationStyle = .fullScreen
                rootViewController.present(navigationController, animated: true, completion: nil)
            }
        }
    }

    public func scanNFC(callback: EkycCallback? = nil) {
        let vc = ScanNFCViewController.storyboardViewController
        // Pass callback to view controller
        vc.ekycCallback = callback

        // Find the root view controller using the modern approach
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let rootViewController = windowScene.windows.first?.rootViewController
        {
            // Try to find navigation controller in the hierarchy
            if let navigationController = rootViewController as? UINavigationController {
                // Root is a navigation controller
                navigationController.pushViewController(vc, animated: true)
            } else if let navigationController = rootViewController.navigationController {
                // Root has a navigation controller
                navigationController.pushViewController(vc, animated: true)
            } else {
                // No navigation controller found, create one and present it
                let navigationController = UINavigationController(rootViewController: vc)
                navigationController.modalPresentationStyle = .fullScreen
                rootViewController.present(navigationController, animated: true, completion: nil)
            }
        }
    }

    public func livenessCheck(clienttransaction: String, callback: EkycCallback? = nil) {
        let vc = LivenessViewController.storyboardViewController
        vc.clienttransaction = clienttransaction
        // Pass callback to view controller
        vc.ekycCallback = callback

        // Find the root view controller using the modern approach
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let rootViewController = windowScene.windows.first?.rootViewController
        {
            // Try to find navigation controller in the hierarchy
            if let navigationController = rootViewController as? UINavigationController {
                // Root is a navigation controller
                navigationController.pushViewController(vc, animated: true)
            } else if let navigationController = rootViewController.navigationController {
                // Root has a navigation controller
                navigationController.pushViewController(vc, animated: true)
            } else {
                // No navigation controller found, create one and present it modally
                let navController = UINavigationController(rootViewController: vc)
                navController.modalPresentationStyle = .fullScreen
                rootViewController.present(navController, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Private Methods
    private func setupIDCardReader() {
        APIService.shared.getConfig(requestString: "GetConfig")
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: {
                    completion in
                    switch completion {
                    case .finished:
                        debugPrint("✅ Success")
                    case .failure(let error):
                        debugPrint("❌ Error API: \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] response in
                    if response.errorCode == 0 {
                        // Lưu trữ config values
                        self?.privateKey = response.data.privateKey
                        self?.publicKey = response.data.publicKey
                        self?.appId = response.data.appId
                        self?.ekycUrl = response.data.baseURL

                        // Setup IDCardReader với config từ API
                        self?.setupIDCardReaderWithConfig()
                    } else {
                        debugPrint("❌ Error API: \(response.errorMessage)")
                    }
                }
            )
            .store(in: &self.cancellables)
    }

    private func setupIDCardReaderWithConfig() {
        // Config eKYC
        IDCardReaderManager.shared.setup(
            serverUrl: ekycUrl + "ekyc", appId: appId, publicKey: publicKey, privateKey: privateKey)
        IDCardReaderManager.shared.setLocalizeTexts(reading: "Reading")
        IDCardReaderManager.shared.setLocalizeTexts(
            requestPresentCard: "Vui lòng đưa CCCD vào",
            authenticating: "Đang xác thực",
            reading: "Đang đọc",
            errorReading: "CCCD không hợp lệ. Vui lòng kiểm tra lại.",
            successReading: "Đọc thẻ thành công",
            retry: "Đang thử lại")

        Networking.shared.setup(
            appId: appId, logLevel: .debug, url: ekycUrl + "face-matching", publicKey: publicKey,
            privateKey: privateKey)
        _ = Networking.shared.generateDeviceInfor()
    }
}
