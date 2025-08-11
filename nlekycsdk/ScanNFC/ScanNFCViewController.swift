//
//  ScanNFCViewController.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import UIKit
import IDCardReader
import Combine
import Foundation

class ScanNFCViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    let encoder = JSONEncoder()
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            // Fallback on earlier versions
        }
        title = "Quét NFC"
        setupTableview()
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
    
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        guard let cardNumber  = CardManager.cardNumber, let dob = CardManager.dob, let doe = CardManager.doe else { return  }
        Task {[weak self] in
            guard let self = self else { return }
            do {
                let data = try await IDCardReaderManager.shared.initTransaction()
                let parsedInformation = try await IDCardReaderManager.shared.readIDCard(cardId: cardNumber, dateOfBirth: dob, dateOfExpiry: doe, transactionId: data.data)
                
                // Convert to JSON string
                let jsonString = IDCardJSONConverter.convertToJSONString(parsedInformation)
                
                DispatchQueue.main.async {
                    var card = CardInformation(card: parsedInformation)
                    card.documentNumber = cardNumber
                    card.faceString = parsedInformation.faceString
                    card.readIdCardRequestId = parsedInformation.requestId
                    CardManager.temporaryCard = card
                    let vc = LivenessViewController.storyboardViewController
                    vc.clienttransaction = parsedInformation.requestId
                    
                    // Save log
                    APIService.shared.saveLogData(
                        requestString: "writeLogNfc",
                        qtsRequestLog: "\(jsonString)",
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
                                self.show(vc, sender: nil)
                            } else {
                                print("❌ Error API: \(String(describing: response.errorMessage))")
                            }
                        }
                    ).store(in: &self.cancellables)
                }
            } catch _ as CardValidationError {
                ()
            } catch let error as NFCPassportReaderError {
                switch error {
                case .UserCanceled:
                    ()
                case .InvalidMRZKey:
//                        Constants.Alert.showErrorAlert(self, message: "CCCD không hợp lệ. Vui lòng kiểm tra lại.")
                    ()
                default:
                    ()
                }
            } catch {
                ()
            }
            
        }
        
    }
}
extension ScanNFCViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: RegistrationLivenessInstructionTableViewCell.identifier, for: indexPath) as! RegistrationLivenessInstructionTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.textColor = UIColor.neutralColor800
        cell.textLabel?.numberOfLines = 0
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 12

        if indexPath.row == 0 {
            cell.textLabel?.text = "\n • Bỏ ốp và các vật dụng bao quanh điện thoại trước khi bắt đầu.\n"
            cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
        }else if indexPath.row == 1 {
            cell.textLabel?.text = " • Đặt CCCD ở phía sau điện thoại và di chuyển chậm để tìm vị trí thẻ NFC.\n"
            cell.layer.cornerRadius = 0
        }else if indexPath.row == 2 {
            cell.textLabel?.text = " • Giữ CCCD tại vị trí NFC đến khi quá trình quét hoàn tất.\n"
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        return cell
    }
}
extension ScanNFCViewController : StoryboardInitialization {
    typealias Element = ScanNFCViewController
    static var storyBoard: AppStoryboard = .Main
}


