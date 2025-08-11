//
//  LivenessVC.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import UIKit
import LivenessCloud

class LivenessVC: UIViewController, LivenessUtilityDetectorDelegate {

    @IBOutlet weak var previewView: UIView!
    var livenessDetector: LivenessUtilityDetector?
    var transactionId = ""
    var clientTransaction = ""
    override func viewDidLoad() {
        super.viewDidLoad()

//        livenessDetector = LivenessUtil.createLivenessDetector(previewView: self.previewView, threshold: .low,delay: 0, smallFaceThreshold: 0.25, debugging: true, delegate: self, livenessMode: .threeDimension,isWink: true,additionParam: ["clientTransactionId":clientTransaction])
//        Task{
//            do{
//                try await Networking.shared.updateloadImage(image: UIImage.init(named: "alpha.png")!, threshold: 1, thema: 1)
//            }catch{
//
//            }
//        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task{
            do{
                try livenessDetector?.getVerificationRequiresAndStartSession(transactionId: transactionId)
            }catch{
                
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        livenessDetector?.stopLiveness()
    }
    func liveness(liveness: LivenessUtilityDetector, didFail withError: LivenessError) {
        print("Liveness failed because of \(withError)")
        if withError.rawValue == LivenessError.twoFace.rawValue{
            print("two face")
        }
    }
    func liveness(liveness: LivenessUtilityDetector, startLivenessAction action: LivenessAction) {
        print(action.rawValue)
    }
    func liveness(liveness: LivenessUtilityDetector, didFinish verificationImage: UIImage, livenesScore: Float, faceMatchingScore: Float, result: Bool, message: String, videoURL: URL?, response: LivenessResult?) {
        let alert = UIAlertController(title: "Info", message: "Kết quả \(result) \nlivenesScore:\(livenesScore)\nfaceMatchingScore:\(faceMatchingScore)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
        self.present(alert, animated: true)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
