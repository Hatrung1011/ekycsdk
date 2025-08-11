//
//  nlekycsdk.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import UIKit
import IDCardReader
import FlashLiveness
import Combine

public class NLeKYCSdkManager: UIViewController  {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    static let shared = NLeKYCSdkManager()
    
    // Config values - sẽ được set sau khi API call thành công
    private var privateKey = ""
    private var publicKey = ""
    private var appId = ""
    private var ekycUrl = ""

    public func initSDK() {
        setupIDCardReader()
    }
    
    public func livenessCheck(clienttransaction: String) {
        Task {
            do {
                let response = try await Networking.shared.initTransaction(additionParam: ["clientTransactionId": clienttransaction])
                if response.status == 200{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LivenessFlashVC") as! LivenessFlashVC
                    vc.transactionId = response.data
                    vc.clientTransaction = clienttransaction
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }catch{
                let alert = UIAlertController(title: "Info", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                self.present(alert, animated: true)
            }
        }
    }

    private func setupIDCardReader() {
        APIService.shared.getConfig(requestString: "GetConfig")
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        print("✅ API call success")
                    case .failure(let error):
                        print("❌ Error API: \(error.localizedDescription)")
                        // Fallback với default values nếu cần
                        self?.setupWithDefaultValues()
                    }
                },
                receiveValue: { [weak self] response in
                    print("Response: \(response)")
                    
                    if response.errorCode == 0 {
                        // Lưu trữ config values
                        self?.privateKey = response.data.privateKey
                        self?.publicKey = response.data.publicKey
                        self?.appId = response.data.appId
                        self?.ekycUrl = response.data.baseURL
                        
                        // Setup IDCardReader với config từ API
                        self?.setupIDCardReaderWithConfig()
                    } else {
                        print("❌ Error API: \(response.errorMessage)")
                        // Fallback với default values
                        self?.setupWithDefaultValues()
                    }
                }
            )
            .store(in: &self.cancellables)
    }
    
    private func setupIDCardReaderWithConfig() {
        // Config eKYC
        IDCardReaderManager.shared.setup(serverUrl: ekycUrl + "ekyc", appId: appId, publicKey: publicKey, privateKey: privateKey)
        IDCardReaderManager.shared.setLocalizeTexts(reading: "Reading")
        IDCardReaderManager.shared.setLocalizeTexts(requestPresentCard: "Vui lòng đưa CCCD vào",
                                                    authenticating: "Đang xác thực",
                                                    reading: "Đang đọc",
                                                    errorReading: "CCCD không hợp lệ. Vui lòng kiểm tra lại.",
                                                    successReading: "Đọc thẻ thành công",
                                                    retry: "Đang thử lại")
        
        Networking.shared.setup(appId: appId, logLevel: .debug, url: ekycUrl + "face-matching", publicKey: publicKey, privateKey: privateKey)
        let response = Networking.shared.generateDeviceInfor()
    }
    
    private func setupWithDefaultValues() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Lỗi kết nối",
                message: "Không thể tải cấu hình từ server. Vui lòng kiểm tra kết nối mạng và thử lại.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.present(alert, animated: true)
            }
        }
    }
}
