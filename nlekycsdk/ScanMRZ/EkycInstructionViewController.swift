//
//  EkycInstructionViewController.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import UIKit

class EkycInstructionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var privacyLb: UILabel!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        } else {
            // Fallback on earlier versions
        }
        title = "Xác thực thông tin"
        setupTableview()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
//        let attributedString = NSMutableAttributedString(string: "Bằng việc đi tiếp, bạn đã đọc và đồng ý với Điều khoản & điều kiện sử dụng dịch vụ NDA"
//                                                         , attributes: [.foregroundColor: UIColor.neutralColor800,
//                                                                        .font: UIFont.systemFont(ofSize: 12)])
//
//        let _ = attributedString.setAsLink(textToFind: "Điều khoản & điều kiện",
//                                           linkURL: "",
//                                           color: UIColor.supportsColorLinkLightColorLink500,
//                                   font: UIFont.systemFont(ofSize: 12))
//        privacyLb.attributedText = attributedString
//        privacyLb.isUserInteractionEnabled = true
//        privacyLb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLabel(gesture:))))
        self.privacyLb.isHidden = true
    }
    
    func setupTableview() {
        tableView.tableFooterView = UIView()
        tableView.registerCell(EkycInstructionTableViewCell.self)
//        tableView.backgroundColor = UIColor(r: 240, g: 240, b: 242)
//        view.backgroundColor = UIColor(r: 240, g: 240, b: 242)
        tableView.backgroundColor = .clear
        view.backgroundColor = .clear
    }
    // MARK: Do something
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        if gesture.didTapAttributedString("Điều khoản & điều kiện", in: privacyLb) {
            
        }
    }
    
    //@IBOutlet weak var nameTextField: UITextField!
    @IBAction func nextBtnTapped(sender: UIButton) {
        let vc = ScanMRZViewController.storyboardViewController
        self.show(vc, sender: nil)
//        Task {
//            do {
//                let readCardId = "1c12693e-0b2c-4e81-9d8e-096069c46747"
////                let res = try await IprLivenessManager.initTransaction(options: InitTransactionOptions(clientTransactionId: readCardId))
////                guard let token = res.data?.verifyToken else {
////                    print("🔹 after initTransaction error: \(res.data)")
////                    throw NSError(domain: res.signature, code: res.status)
////                }
////                print("🔹 after initTransaction: \(token)")
//
//                let res = try await IprLivenessManager.liveness(config: IprLivenessConfig(
//                    readCardRequestId: readCardId
//                ))
//                print(res)
//            } catch {
//
//            }
//        }
    }
}

extension EkycInstructionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EkycInstructionTableViewCell.identifier, for: indexPath) as! EkycInstructionTableViewCell
        if indexPath.row == 0 {
            cell.iconView.image = UIImage(named: "ic_scanMRZ")
            cell.titleLb.text = "Quét mã MRZ"
            cell.subTitleLb.text = "Quét mã MRZ ở mặt sau CCCD gắn chip để lấy mã khóa truy xuất thông tin cá nhân trong Chip."
        }else if indexPath.row == 1 {
            cell.iconView.image = UIImage(named: "ic_readData")
            cell.titleLb.text = "Đọc dữ liệu trên CCCD"
            cell.subTitleLb.text = "Đưa CCCD gắn Chip vào khu vực chip NFC đằng sau điện thoại của bạn."
        }else {
            cell.iconView.image = UIImage(named: "ic_liveness")
            cell.titleLb.text = "So khớp khuôn mặt"
            cell.subTitleLb.text = "Đưa khuôn mặt vào khung hình và thực hiện theo hướng dẫn để xác thực."
        }
        
        return cell
    }
}
extension EkycInstructionViewController : StoryboardInitialization {
    typealias Element = EkycInstructionViewController
    static var storyBoard: AppStoryboard = .Main
}


extension NSMutableAttributedString {

    public func setAsLink(textToFind:String, linkURL:String, color: UIColor, font: UIFont) -> Bool {

        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttributes([.link : linkURL, .foregroundColor: color, .font: font], range: foundRange)
            return true
        }
        return false
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedString(_ string: String, in label: UILabel) -> Bool {
        
        guard let text = label.text else {
            
            return false
        }
        
        let range = (text as NSString).range(of: string)
        return self.didTapAttributedText(label: label, inRange: range)
    }
    
    private func didTapAttributedText(label: UILabel, inRange targetRange: NSRange) -> Bool {
        
        guard let attributedText = label.attributedText else {
            
            assertionFailure("attributedText must be set")
            return false
        }
        
        let textContainer = createTextContainer(for: label)
        
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        if let font = label.font {
            
            textStorage.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, attributedText.length))
        }
        textStorage.addLayoutManager(layoutManager)
        
        let locationOfTouchInLabel = location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let alignmentOffset = aligmentOffset(for: label)
        
        let xOffset = ((label.bounds.size.width - textBoundingBox.size.width) * alignmentOffset) - textBoundingBox.origin.x
        let yOffset = ((label.bounds.size.height - textBoundingBox.size.height) * alignmentOffset) - textBoundingBox.origin.y
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - xOffset, y: locationOfTouchInLabel.y - yOffset)
        
        let characterTapped = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        let lineTapped = Int(ceil(locationOfTouchInLabel.y / label.font.lineHeight)) - 1
        let rightMostPointInLineTapped = CGPoint(x: label.bounds.size.width, y: label.font.lineHeight * CGFloat(lineTapped))
        let charsInLineTapped = layoutManager.characterIndex(for: rightMostPointInLineTapped, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return characterTapped < charsInLineTapped ? targetRange.contains(characterTapped) : false
    }
    
    private func createTextContainer(for label: UILabel) -> NSTextContainer {
        
        let textContainer = NSTextContainer(size: label.bounds.size)
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        return textContainer
    }
    
    private func aligmentOffset(for label: UILabel) -> CGFloat {
        
        switch label.textAlignment {
            
        case .left, .natural, .justified:
            
            return 0.0
        case .center:
            
            return 0.5
        case .right:
            
            return 1.0
            
            @unknown default:
            
            return 0.0
        }
    }
}

