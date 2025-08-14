//
//  ScanMRZViewController.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import Combine
import IDCardReader
import QKMRZParser
import UIKit

class ScanMRZViewController: UIViewController {
    @IBOutlet weak var mrzScannerView: QKMRZScannerView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var cardNumberTxt: ERTextField!
    @IBOutlet weak var dobTxt: ERTextField!
    @IBOutlet weak var doeTxt: ERTextField!

    var doeString: String = ""
    @IBOutlet weak var resultViewBottomConstraint: NSLayoutConstraint!

    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    var documentNumber: String?

    // Callback for demo app
    var ekycCallback: NLeKYCSdkManager.EkycCallback?

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            // Fallback on earlier versions
        }
        title = "Quét mã MRZ"
        mrzScannerView.delegate = self
        resultView.clipsToBounds = true
        resultView.layer.cornerRadius = 20
        resultView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        dobTxt.showAsDatePicker(data: [])
        doeTxt.showAsDatePicker(data: [])
        dobTxt.delegate = self
        doeTxt.delegate = self

        dobTxt.placeholder = "dd/mm/yyyy"
        doeTxt.placeholder = "dd/mm/yyyy"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mrzScannerView.startScanning()
        let appearance = UINavigationBarAppearance.defaultAppearance()
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
        ]
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = textAttributes
        appearance.backgroundColor = .black
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.tintColor = .white
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mrzScannerView.stopScanning()
        navigationController?.navigationBar.standardAppearance =
            UINavigationBar.appearance().standardAppearance
        navigationController?.navigationBar.scrollEdgeAppearance =
            UINavigationBar.appearance().scrollEdgeAppearance
        navigationController?.navigationBar.compactAppearance =
            UINavigationBar.appearance().compactAppearance
        self.navigationController?.navigationBar.tintColor =
            UIColor.frameworkColor(named: "Neutral Color900") ?? UIColor.black
    }

    @IBAction func scanMRZManualBtnTapped(_ sender: Any) {
        showResultView()
    }

    @IBAction func closeResultBtnTapped(_ sender: Any) {
        hideResultView()
        mrzScannerView.startScanning()
    }

    private func showResultView() {
        resultViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    private func hideResultView() {
        resultViewBottomConstraint.constant = -480
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func nextBtnTapped(_ sender: Any) {
        guard let cardNumber = cardNumberTxt.text, cardNumber.count >= 9 else {
            Constants.Alert.showErrorAlert(
                self, message: "Vui lòng kiểm tra lại số CCCD của bạn, và nhập đủ 9 số cuối.")
            return
        }
        CardManager.cardNumber = String(cardNumber.suffix(9))
        CardManager.dob = dobTxt.text
        CardManager.doe = doeString

        guard let card = CardManager.cardNumber, let dob = CardManager.dob,
            let doe = CardManager.doe, !card.isEmpty, !dob.isEmpty, !doe.isEmpty
        else {
            Constants.Alert.showErrorAlert(self, message: "Vui lòng nhập đủ thông tin.")
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let date = dateFormatter.date(from: doe) {
            dateFormatter.dateFormat = "yyyy"
            let val = dateFormatter.string(from: date)
            if val != "1999" && date < Date() {

                Constants.Alert.showErrorAlert(
                    self, message: "CCCD đã hết hạn. Vui lòng kiểm tra lại")
                return
            }
        }

        let qtsLogStringJson =
            "{\"documentNumber\":\"\(self.documentNumber ?? "")\",\"birthdate\":\"\(CardManager.dob ?? "")\",\"expiryDate\":\"\(CardManager.doe ?? "")\"}"

        // Save log
        APIService.shared.saveLogData(
            requestString: "writeLogMrz",
            qtsRequestLog: qtsLogStringJson,
            checksum: ""
        ).receive(on: DispatchQueue.main)
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
                receiveValue: {
                    response in
                    if response.errorCode == 0 {
                        // Do something
                    } else {
                        debugPrint("❌ Error API: \(String(describing: response.errorMessage))")
                    }
                }
            ).store(in: &self.cancellables)

        // Gọi callback với qtsLogStringJson
        ekycCallback?(qtsLogStringJson)

        // Navigation
        self.dismiss(animated: true, completion: nil)
    }

}
extension ScanMRZViewController: StoryboardInitialization {
    typealias Element = ScanMRZViewController
    static var storyBoard: AppStoryboard = .Main
}

extension ScanMRZViewController: QKMRZScannerViewDelegate {
    func mrzScannerView(_ mrzScannerView: QKMRZScannerView, didFind scanResult: QKMRZScanResult) {
        self.documentNumber = scanResult.documentNumber
        cardNumberTxt.text = String(scanResult.personalNumber.prefix(12))

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        if let date = scanResult.birthdate {
            dobTxt.text = dateFormatter.string(from: date)
        }

        if let date = scanResult.expiryDate {
            doeTxt.text = dateFormatter.string(from: date)

            doeString = dateFormatter.string(from: date)
            if doeString == "31/12/1999" {
                doeTxt.text = "Không thời hạn"
            }
        }
        //        let image = scanResult.documentImage
        //        interactor?.backCardImage = scanResult.documentImage
        showResultView()
    }
}

extension ScanMRZViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let mode = UIDatePicker.Mode.date
        RPicker.selectDate(
            title: "Chọn ngày", cancelText: "Huỷ", doneText: "Chọn", datePickerMode: mode,
            selectedDate: Date(), minDate: nil, maxDate: nil, style: .Wheel
        ) { [weak textField] date in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"

            let value = dateFormatter.string(from: date)
            textField?.text = value
        }
        return false
    }
}
