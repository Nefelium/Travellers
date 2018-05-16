//
//  UsersTableViewCell.swift
//  Travellers
//
//  Created by admin on 06.05.2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    var userCell: UserModel? {
        didSet {
            userIdLabel.text = "\(userCell?.id ?? 0)"
            userLabel.text = userCell?.name
        }
    }
}
