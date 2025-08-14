//
//  LivenessViewController.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import FlashLiveness
import SVProgressHUD
import UIKit

class LivenessViewController: UIViewController {
    @IBOutlet weak var btnNotShowAgain: UIButton!
    var clienttransaction = ""
    var ekycCallback: NLeKYCSdkManager.EkycCallback?

    // MARK: Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            if scene == "page_embed" {
                let vc = segue.destination as? PageViewController
                let page1 = LivenessInstructionItemController.storyboardViewController
                page1.instruction = "Bỏ kính, mũ, khẩu trang trước khi thực hiện so khớp"
                let shouldImage1 = UIImage.frameworkImage(named: "ic_liveness")
                let shouldNotImage1 = UIImage.frameworkImage(named: "ic_liveness_1")
                page1.should = shouldImage1
                page1.shouldNot = shouldNotImage1

                let page2 = LivenessInstructionItemController.storyboardViewController
                page2.instruction = "Lựa chọn nơi có ánh sáng đầy đủ, không sáng quá hoặc tối quá"
                let shouldImage2 = UIImage.frameworkImage(named: "ic_liveness")
                let shouldNotImage2 = UIImage.frameworkImage(named: "ic_liveness_2")
                page2.should = shouldImage2
                page2.shouldNot = shouldNotImage2

                let page3 = LivenessInstructionItemController.storyboardViewController
                page3.instruction = "Đảm bảo chỉ có duy nhất khuôn mặt của bạn trong khung hình"
                let shouldImage3 = UIImage.frameworkImage(named: "ic_liveness")
                let shouldNotImage3 = UIImage.frameworkImage(named: "ic_liveness_3")
                page3.should = shouldImage3
                page3.shouldNot = shouldNotImage3

                vc?.pages = [
                    page1, page2, page3,
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
        setupBackButton()
        self.btnNotShowAgain.isSelected = true
    }
    
    private func setupBackButton() {
        // Tạo back button với icon và title
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left")?.withTintColor(
                .black, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )

        navigationItem.leftBarButtonItem = backButton
    }

    @objc private func backButtonTapped() {
        // Kiểm tra xem có thể pop về màn hình trước không
        if let navigationController = self.navigationController,
            navigationController.viewControllers.count > 1
        {
            navigationController.popViewController(animated: true)
        } else {
            // Nếu không có màn hình trước, dismiss modal
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func nextBtnTapped(_ sender: Any) {
        Task {
            do {
                let response = try await Networking.shared.initTransaction(additionParam: [
                    "clientTransactionId": clienttransaction
                ])
                if response.status == 200 {
                    let vc = LivenessFlashVC.storyboardViewController
                    vc.transactionId = response.data
                    vc.clientTransaction = self.clienttransaction
                    vc.ekycCallback = self.ekycCallback
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } catch {
                let alert = UIAlertController(
                    title: "Info", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                self.present(alert, animated: true)
            }
        }
    }

    @IBAction func onPressNotShowAgain(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
}

extension LivenessViewController: StoryboardInitialization {
    typealias Element = LivenessViewController
    static var storyBoard: AppStoryboard = .Main
}
