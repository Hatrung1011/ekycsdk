//
//  ScanNFCViewController.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import Combine
import Foundation
import IDCardReader
import UIKit

class ScanNFCViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()

    let encoder = JSONEncoder()

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
        title = "Quét NFC"
        setupBackButton()
        setupTableview()
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

    func setupTableview() {
        tableView.tableFooterView = UIView()
        tableView.registerCell(RegistrationLivenessInstructionTableViewCell.self)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELL")
        //        tableView.backgroundColor = UIColor(r: 240, g: 240, b: 242)
        //        view.backgroundColor = UIColor(r: 240, g: 240, b: 242)
        tableView.backgroundColor = .clear
        view.backgroundColor = .clear
    }
    // MARK: Do something
    func getRequestId() -> String {
        var rs = ""
        guard let cardNumber = CardManager.cardNumber, let dob = CardManager.dob,
            let doe = CardManager.doe
        else { return rs }
        Task { [weak self] in
            guard self != nil else { return }
            do {
                let data = try await IDCardReaderManager.shared.initTransaction()
                let parsedInformation = try await IDCardReaderManager.shared.readIDCard(
                    cardId: cardNumber, dateOfBirth: dob, dateOfExpiry: doe,
                    transactionId: data.data)

                rs = parsedInformation.requestId

            } catch _ as CardValidationError {
                ()
            } catch let error as NFCPassportReaderError {
                switch error {
                case .UserCanceled:
                    ()
                case .InvalidMRZKey:
                    ()
                default:
                    ()
                }
            } catch {
                ()
            }
        }
        return rs
    }

    @IBAction func nextBtnTapped(_ sender: Any) {
        guard let cardNumber = CardManager.cardNumber, let dob = CardManager.dob,
            let doe = CardManager.doe
        else {
            Constants.Alert.showErrorAlert(self, message: "Vui lòng kiểm tra lại thông tin CCCD.")
            return
        }

        // Show loading indicator
        let loadingAlert = UIAlertController(
            title: nil, message: "Đang quét NFC...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(
            frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        loadingAlert.view.addSubview(loadingIndicator)
        present(loadingAlert, animated: true, completion: nil)

        Task { [weak self] in
            guard let self = self else { return }
            do {
                let data = try await IDCardReaderManager.shared.initTransaction()
                let parsedInformation = try await IDCardReaderManager.shared.readIDCard(
                    cardId: cardNumber, dateOfBirth: dob, dateOfExpiry: doe,
                    transactionId: data.data)

                await MainActor.run {
                    loadingAlert.dismiss(animated: true) {
                        // Save the parsed information to CardManager for later use
                        let cardInfo = CardInformation(card: parsedInformation)
                        CardManager.cardInformation = cardInfo

                        // Call callback with success - convert to JSON string
                        let jsonString = IDCardJSONConverter.convertToJSONString(parsedInformation)
                        self.ekycCallback?(jsonString)
                        self.dismiss(animated: true, completion: nil)
                    }
                }

            } catch _ as CardValidationError {
                await MainActor.run {
                    loadingAlert.dismiss(animated: true) {
                        Constants.Alert.showErrorAlert(
                            self, message: "Thông tin CCCD không hợp lệ.")
                    }
                }
            } catch let error as NFCPassportReaderError {
                await MainActor.run {
                    loadingAlert.dismiss(animated: true) {
                        switch error {
                        case .UserCanceled:
                            Constants.Alert.showErrorAlert(
                                self, message: "Người dùng đã hủy quét NFC.")
                        case .InvalidMRZKey:
                            Constants.Alert.showErrorAlert(self, message: "Khóa MRZ không hợp lệ.")
                        default:
                            Constants.Alert.showErrorAlert(
                                self, message: "Lỗi quét NFC: \(error.localizedDescription)")
                        }
                    }
                }
            } catch {
                await MainActor.run {
                    loadingAlert.dismiss(animated: true) {
                        Constants.Alert.showErrorAlert(
                            self, message: "Lỗi không xác định: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
extension ScanNFCViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.textColor =
            UIColor.frameworkColor(named: "Neutral Color800") ?? UIColor.darkGray
        cell.textLabel?.numberOfLines = 0
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 12

        if indexPath.row == 0 {
            cell.textLabel?.text =
                "\n • Bỏ ốp và các vật dụng bao quanh điện thoại trước khi bắt đầu.\n"
            cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        } else if indexPath.row == 1 {
            cell.textLabel?.text =
                " • Đặt CCCD ở phía sau điện thoại và di chuyển chậm để tìm vị trí thẻ NFC.\n"
            cell.layer.cornerRadius = 0
        } else if indexPath.row == 2 {
            cell.textLabel?.text = " • Giữ CCCD tại vị trí NFC đến khi quá trình quét hoàn tất.\n"
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }

        return cell
    }
}
extension ScanNFCViewController: StoryboardInitialization {
    typealias Element = ScanNFCViewController
    static var storyBoard: AppStoryboard = .Main
}
