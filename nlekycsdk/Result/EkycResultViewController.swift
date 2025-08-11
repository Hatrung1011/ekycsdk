//
//  EkycResultViewController.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import UIKit

class EkycResultViewController: UIViewController {
    @IBOutlet weak var btnReturnHome: UIButton! {
        didSet {
//            self.btnReturnHome.setimage
        }
    }
    var cardInfo: CardInformation?
    var items: [UITableViewCell.CellConfiguration]?
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.estimatedRowHeight = 50
            self.tableView.rowHeight = UITableView.automaticDimension
            self.tableView.registerCell(ShowCardInfoTextTableViewCell.self)
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let verifyDateAttrs = NSMutableAttributedString(string: "Thời gian xác thực: ", attributes: [
            .foregroundColor: UIColor(named: "Neutral Color900")!,
            .font: UIFont.systemFont(ofSize: 13)
        ])
        verifyDateAttrs.append(NSAttributedString(string: Date().string(withFormat: "HH:mm - dd/MM/yyyy"), attributes: [
            .foregroundColor: UIColor(named: "Neutral Color700")!,
            .font: UIFont.systemFont(ofSize: 13)
        ]))
        self.lblDate.attributedText = verifyDateAttrs
        self.setupCardData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupTableview() {
        view.backgroundColor = .clear
    }
    
    func replaceFiveCharacters(from input: String) -> String {
        guard input.count >= 9 else { return input } // Đảm bảo có ít nhất 9 ký tự để thay thế từ ký tự số 5
        
        let startIndex = input.index(input.startIndex, offsetBy: 4)  // Vị trí ký tự số 5
        let endIndex = input.index(startIndex, offsetBy: 5) // Vị trí sau 5 ký tự tiếp theo
        
        var modifiedString = input
        modifiedString.replaceSubrange(startIndex..<endIndex, with: "xxxxx")
        
        return modifiedString
    }
    
    func setupCardData() {
        let credentialSharing = self.cardInfo
        self.items = []
        if let citizen_identify = credentialSharing?.citizenIdentify {
            self.items?.append(UITableViewCell.CellConfiguration(
                text: "CCCD",
                secondaryText: citizen_identify
            ))
        }
        if let expireDate = credentialSharing?.dateOfExpiry {
            self.items?.append(UITableViewCell.CellConfiguration(
                text: "Ngày hết hạn",
                secondaryText: expireDate
            ))
        }
        if let fullName = credentialSharing?.fullName {
            self.items?.append(UITableViewCell.CellConfiguration(
                text: "Họ tên",
                secondaryText: fullName
            ))
        }
        if let dateOfBirth = credentialSharing?.dateOfBirth {
            self.items?.append(UITableViewCell.CellConfiguration(
                text: "Ngày sinh",
                secondaryText: dateOfBirth
            ))
        }
        if let gender = credentialSharing?.gender {
            self.items?.append(UITableViewCell.CellConfiguration(
                text: "Giới tính",
                secondaryText: gender
            ))
        }
        if let placeOfResidence = credentialSharing?.placeOfResidence {
            self.items?.append(UITableViewCell.CellConfiguration(
                text: "Địa chỉ thường trú",
                secondaryText: placeOfResidence
            ))
        }
        if let placeOfOrigin = credentialSharing?.placeOfOrigin {
            self.items?.append(UITableViewCell.CellConfiguration(
                text: "Quê quán",
                secondaryText: placeOfOrigin
            ))
        }
        if let nationality = credentialSharing?.nationality {
            self.items?.append(UITableViewCell.CellConfiguration(
                text: "Quốc tịch",
                secondaryText: nationality
            ))
        }
        
        if let religion = credentialSharing?.religion {
            self.items?.append(UITableViewCell.CellConfiguration(
                text: "Tôn giáo",
                secondaryText: religion
            ))
        }
        if let dateProvide = credentialSharing?.dateProvide {
            self.items?.append(UITableViewCell.CellConfiguration(
                text: "Ngày cấp",
                secondaryText: dateProvide
            ))
        }
        
        if let ethnic = credentialSharing?.ethnic {
            self.items?.append(UITableViewCell.CellConfiguration(
                text: "Dân tộc",
                secondaryText: ethnic
            ))
        }
        
        if let oldCitizenIdentify = credentialSharing?.oldCitizenIdentify {
            self.items?.append(UITableViewCell.CellConfiguration(
                text: "Số CMND cũ",
                secondaryText: oldCitizenIdentify
            ))
        }
        if let personalIdentification = credentialSharing?.personalIdentification {
            self.items?.append(UITableViewCell.CellConfiguration(
                text: "Đặc điểm nhận dạng",
                secondaryText: personalIdentification
            ))
        }
        if let fatherName = credentialSharing?.fatherName {
            self.items?.append(UITableViewCell.CellConfiguration(
                text: "Họ tên bố",
                secondaryText: fatherName
            ))
        }
        if let motherName = credentialSharing?.motherName {
            self.items?.append(UITableViewCell.CellConfiguration(
                text: "Họ tên mẹ",
                secondaryText: motherName
            ))
        }
        if let partnerName = credentialSharing?.partnerName {
            self.items?.append(UITableViewCell.CellConfiguration(
                text: "Họ tên vợ/chồng",
                secondaryText: partnerName
            ))
        }
        self.tableView.reloadData()
    }
    
    @IBAction func onPressReturnHome(_ sender: Any) {
        let vc = EkycInstructionViewController.storyboardViewController
        self.navigationController?.setViewControllers([vc], animated: true)
    }
}

extension EkycResultViewController: StoryboardInitialization {
    typealias Element = EkycResultViewController
    static var storyBoard: AppStoryboard = .Main
}

extension EkycResultViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShowCardInfoTextTableViewCell.identifier, for: indexPath) as! ShowCardInfoTextTableViewCell
        if let item = self.items?[indexPath.row] as? UITableViewCell.CellConfiguration {
            cell.contentLb.text = item.secondaryText
            cell.nameLb.text = item.text
        }
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        cell.bottomLine.isHidden = true
        return cell
    }
}
