//
//  LivenessFlashVC.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import UIKit
import FlashLiveness
import Combine

class LivenessFlashVC: UIViewController {
    var livenessDetector: LivenessUtilityDetector?
    
    @IBOutlet weak var previewView: UIView!
    var transactionId = ""
    var clientTransaction = ""
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.livenessDetector = LivenessUtil.createLivenessDetector(previewView: self.previewView, mode: .online, delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try self.livenessDetector?.getVerificationRequiresAndStartSession(transactionId: self.transactionId)
        } catch{
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        livenessDetector?.stopLiveness()
    }
}

extension LivenessFlashVC: LivenessUtilityDetectorDelegate {
    func liveness(_ liveness: LivenessUtilityDetector, didFail withError: LivenessError) {
        print("Liveness failed because of \(withError)")
        
    }
    
    func liveness(_ liveness: LivenessUtilityDetector, didFinishWithResult result: LivenessResult) {
        let json = LivenessJsonConverter.convertToJSONString(result)
        
        let vc = EkycResultViewController.storyboardViewController
        
         // Save log
        APIService.shared.saveLogData(
            requestString: "writeLogLiveness",
            qtsRequestLog: "\(json)",
            checksum: ""
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: {
                completion in
                switch completion {
                case .finished:
                    print("✅ API call success")
                case .failure(let error):
                    print("❌ Error API: \(error.localizedDescription)")
                }
            },
            receiveValue: {
                response in
                if response.errorCode == 0 {
                    print("✅ Save log successful")
                    // Navigation to NFC screen
                    vc.cardInfo = CardManager.temporaryCard
                    self.show(vc, sender: nil)
                } else {
                    print("❌ Error API: \(String(describing: response.errorMessage))")
                }
            }
        ).store(in: &self.cancellables)
    }
}
