//
//  LivenessFlashVC.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import Combine
import FlashLiveness
import UIKit

class LivenessFlashVC: UIViewController {
    var livenessDetector: LivenessUtilityDetector?

    @IBOutlet weak var previewView: UIView!
    var transactionId = ""
    var clientTransaction = ""
    var ekycCallback: NLeKYCSdkManager.EkycCallback?

    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.livenessDetector = LivenessUtil.createLivenessDetector(
            previewView: self.previewView, mode: .online, delegate: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try self.livenessDetector?.getVerificationRequiresAndStartSession(
                transactionId: self.transactionId)
        } catch {

        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        livenessDetector?.stopLiveness()
    }
}

extension LivenessFlashVC: StoryboardInitialization {
    typealias Element = LivenessFlashVC
    static var storyBoard: AppStoryboard = .Main
}

extension LivenessFlashVC: LivenessUtilityDetectorDelegate {
    func liveness(_ liveness: LivenessUtilityDetector, didFail withError: LivenessError) {
        debugPrint("Liveness failed because of \(withError)")

    }

    func liveness(_ liveness: LivenessUtilityDetector, didFinishWithResult result: LivenessResult) {
        let livenessJson = LivenessJsonConverter.convertToJSONString(result)

        let vc = EkycResultViewController.storyboardViewController

        // Save log
        APIService.shared.saveLogData(
            requestString: "writeLogLiveness",
            qtsRequestLog: "\(livenessJson)",
            checksum: ""
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: {
                completion in
                switch completion {
                case .finished:
                    debugPrint("✅ API call success")
                case .failure(let error):
                    debugPrint("❌ Error API: \(error.localizedDescription)")
                }
            },
            receiveValue: {
                response in
                if response.errorCode == 0 {
                    debugPrint("✅ Save log successful")
                    // Navigation to NFC screen
                    vc.cardInfo = CardManager.cardInformation
                    vc.ekycCallback = self.ekycCallback

                    // Create combined data for callback
                    if let cardInfo = CardManager.cardInformation {
                        let cardJson = IDCardJSONConverter.convertToJSONString(cardInfo)

                        // Parse both JSONs to combine them
                        if let livenessData = livenessJson.data(using: .utf8),
                            let cardData = cardJson.data(using: .utf8),
                            let livenessDict = try? JSONSerialization.jsonObject(with: livenessData)
                                as? [String: Any],
                            let cardDict = try? JSONSerialization.jsonObject(with: cardData)
                                as? [String: Any]
                        {

                            // Create combined response
                            let combinedResponse: [String: Any] = [
                                "liveness_data": livenessDict,
                                "card_data": cardDict,
                                "status": "success",
                                "message": "Liveness check completed successfully",
                            ]

                            // Convert back to JSON string
                            if let combinedData = try? JSONSerialization.data(
                                withJSONObject: combinedResponse, options: .prettyPrinted),
                                let combinedJsonString = String(data: combinedData, encoding: .utf8)
                            {
                                vc.combinedCallbackData = combinedJsonString
                            }
                        }
                    }

                    self.show(vc, sender: nil)
                } else {
                    debugPrint("❌ Error API: \(String(describing: response.errorMessage))")
                }
            }
        ).store(in: &self.cancellables)
    }
}
