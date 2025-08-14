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
        title = "Xác thực thông tin"
        setupBackButton()
        setupTableview()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.privacyLb.isHidden = true
    }

    func setupTableview() {
        tableView.tableFooterView = UIView()
        tableView.registerCell(EkycInstructionTableViewCell.self)
        tableView.backgroundColor = .clear
        view.backgroundColor = .clear
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
    // MARK: Do something

    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        if gesture.didTapAttributedString("Điều khoản & điều kiện", in: privacyLb) {

        }
    }

    //@IBOutlet weak var nameTextField: UITextField!
    @IBAction func nextBtnTapped(sender: UIButton) {
        let vc = ScanMRZViewController.storyboardViewController
        // Pass callback to next screen
        vc.ekycCallback = self.ekycCallback

        // Check if we're in a navigation controller
        if let navigationController = self.navigationController {
            // We're in a navigation controller, push the view controller
            navigationController.pushViewController(vc, animated: true)
        } else {
            // We're not in a navigation controller, present modally
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension EkycInstructionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: EkycInstructionTableViewCell.identifier, for: indexPath)
            as! EkycInstructionTableViewCell
        if indexPath.row == 0 {
            cell.iconView.image = UIImage.frameworkImage(named: "ic_scanMRZ")
            cell.titleLb.text = "Quét mã MRZ"
            cell.subTitleLb.text =
                "Quét mã MRZ ở mặt sau CCCD gắn chip để lấy mã khóa truy xuất thông tin cá nhân trong Chip."
        } else if indexPath.row == 1 {
            cell.iconView.image = UIImage.frameworkImage(named: "ic_readData")
            cell.titleLb.text = "Đọc dữ liệu trên CCCD"
            cell.subTitleLb.text =
                "Đưa CCCD gắn Chip vào khu vực chip NFC đằng sau điện thoại của bạn."
        } else {
            cell.iconView.image = UIImage.frameworkImage(named: "ic_liveness")
            cell.titleLb.text = "So khớp khuôn mặt"
            cell.subTitleLb.text =
                "Đưa khuôn mặt vào khung hình và thực hiện theo hướng dẫn để xác thực."
        }

        return cell
    }
}
extension EkycInstructionViewController: StoryboardInitialization {
    typealias Element = EkycInstructionViewController
    static var storyBoard: AppStoryboard = .Main
}

extension NSMutableAttributedString {

    public func setAsLink(textToFind: String, linkURL: String, color: UIColor, font: UIFont) -> Bool
    {

        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttributes(
                [.link: linkURL, .foregroundColor: color, .font: font], range: foundRange)
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

            textStorage.addAttribute(
                NSAttributedString.Key.font, value: font,
                range: NSMakeRange(0, attributedText.length))
        }
        textStorage.addLayoutManager(layoutManager)

        let locationOfTouchInLabel = location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let alignmentOffset = aligmentOffset(for: label)

        let xOffset =
            ((label.bounds.size.width - textBoundingBox.size.width) * alignmentOffset)
            - textBoundingBox.origin.x
        let yOffset =
            ((label.bounds.size.height - textBoundingBox.size.height) * alignmentOffset)
            - textBoundingBox.origin.y
        let locationOfTouchInTextContainer = CGPoint(
            x: locationOfTouchInLabel.x - xOffset, y: locationOfTouchInLabel.y - yOffset)

        let characterTapped = layoutManager.characterIndex(
            for: locationOfTouchInTextContainer, in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil)

        let lineTapped = Int(ceil(locationOfTouchInLabel.y / label.font.lineHeight)) - 1
        let rightMostPointInLineTapped = CGPoint(
            x: label.bounds.size.width, y: label.font.lineHeight * CGFloat(lineTapped))
        let charsInLineTapped = layoutManager.characterIndex(
            for: rightMostPointInLineTapped, in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil)

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
