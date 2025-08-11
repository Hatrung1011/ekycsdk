import UIKit
import nlekycsdk

class ViewController: UIViewController {
    
    @IBOutlet weak var initButton: UIButton!
    @IBOutlet weak var livenessButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "NLE KYC SDK Demo"
        
        initButton.setTitle("Khởi tạo SDK", for: .normal)
        initButton.backgroundColor = .systemBlue
        initButton.layer.cornerRadius = 8
        
        livenessButton.setTitle("Kiểm tra Liveness", for: .normal)
        livenessButton.backgroundColor = .systemGreen
        livenessButton.layer.cornerRadius = 8
        livenessButton.isEnabled = false
        
        statusLabel.text = "Chưa khởi tạo SDK"
        statusLabel.textAlignment = .center
    }
    
    @IBAction func initSDKTapped(_ sender: UIButton) {
        statusLabel.text = "Đang khởi tạo SDK..."
        
        // Khởi tạo SDK
        NLeKYCSdkManager.shared.initSDK()
        
        // Simulate delay để demo
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.statusLabel.text = "SDK đã được khởi tạo thành công!"
            self.livenessButton.isEnabled = true
        }
    }
    
    @IBAction func livenessCheckTapped(_ sender: UIButton) {
        let transactionId = "demo-transaction-\(Int.random(in: 1000...9999))"
        
        // Thực hiện kiểm tra liveness
        NLeKYCSdkManager.shared.livenessCheck(clienttransaction: transactionId)
    }
}

// MARK: - Storyboard Setup
extension ViewController {
    static func createFromStoryboard() -> ViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
    }
}
