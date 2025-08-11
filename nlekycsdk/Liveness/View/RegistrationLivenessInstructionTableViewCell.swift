//
//  RegistrationLivenessInstructionTableViewCell.swift
//  nlekycsdk
//
//  Created by Sherwin on 11/8/25.
//

import UIKit

class RegistrationLivenessInstructionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension RegistrationLivenessInstructionTableViewCell: XibInitialization {
    typealias Element = RegistrationLivenessInstructionTableViewCell
}
