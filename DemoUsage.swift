//
//  DemoUsage.swift
//  Demo App
//
//  Created by Sherwin on 11/8/25.
//

import UIKit
import nlekycsdk

class DemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        let scanButton = UIButton(type: .system)
        scanButton.setTitle("Scan MRZ", for: .normal)
        scanButton.addTarget(self, action: #selector(scanMRZButtonTapped), for: .touchUpInside)
        scanButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scanButton)
        NSLayoutConstraint.activate([
            scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc private func scanMRZButtonTapped() {
        // Gọi scanMRZ với callback để nhận qtsLogStringJson
        NLeKYCSdkManager.shared.scanMRZ { [weak self] qtsLogStringJson in
            // Callback được gọi khi user tap back button hoặc hoàn thành scan
            debugPrint("📱 Demo App received callback: \(qtsLogStringJson)")

            // Parse JSON để lấy thông tin
            if let data = qtsLogStringJson.data(using: .utf8),
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            {

                DispatchQueue.main.async {
                    self?.handleCallbackData(json)
                }
            }
        }
    }

    private func handleCallbackData(_ data: [String: Any]) {
        if let action = data["action"] as? String {
            switch action {
            case "back_from_instruction":
                // User đã tap back button từ instruction screen
                showAlert(
                    title: "User Cancelled", message: "User cancelled from instruction screen")

            default:
                // Có dữ liệu MRZ scan
                if let documentNumber = data["documentNumber"] as? String,
                    let birthdate = data["birthdate"] as? String,
                    let expiryDate = data["expiryDate"] as? String
                {

                    let message = """
                        Document Number: \(documentNumber)
                        Birth Date: \(birthdate)
                        Expiry Date: \(expiryDate)
                        """
                    showAlert(title: "MRZ Scan Result", message: message)
                }
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
