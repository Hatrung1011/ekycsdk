//
//  LivenessViewController.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import UIKit
import SVProgressHUD
import FlashLiveness

class LivenessViewController: UIViewController {
    @IBOutlet weak var btnNotShowAgain: UIButton!
    var clienttransaction = ""
    
    // MARK: Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            if scene == "page_embed" {
                let vc = segue.destination as? PageViewController
                let page1 = LivenessInstructionItemController.storyboardViewController
                page1.instruction = "Bỏ kính, mũ, khẩu trang trước khi thực hiện so khớp"
                page1.should = .icLiveness
                page1.shouldNot = .icLiveness1
                let page2 = LivenessInstructionItemController.storyboardViewController
                page2.instruction = "Lựa chọn nơi có ánh sáng đầy đủ, không sáng quá hoặc tối quá"
                page2.should = .icLiveness
                page2.shouldNot = .icLiveness2
                let page3 = LivenessInstructionItemController.storyboardViewController
                page3.instruction = "Đảm bảo chỉ có duy nhất khuôn mặt của bạn trong khung hình"
                page3.should = .icLiveness
                page3.shouldNot = .icLiveness3
                vc?.pages = [
                    page1, page2, page3
                ]
                return
            }
        }
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            // Fallback on earlier versions
        }
        self.btnNotShowAgain.isSelected = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        Task {
            do {
                let response = try await Networking.shared.initTransaction(additionParam: ["clientTransactionId": clienttransaction])
                if response.status == 200{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LivenessFlashVC") as! LivenessFlashVC
                    vc.transactionId = response.data
                    vc.clientTransaction = self.clienttransaction
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }catch{
                let alert = UIAlertController(title: "Info", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func onPressNotShowAgain(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
}

extension LivenessViewController : StoryboardInitialization {
    typealias Element = LivenessViewController
    static var storyBoard: AppStoryboard = .Main
}
