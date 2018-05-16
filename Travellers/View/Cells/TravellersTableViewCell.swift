//
//  TravellersTableViewCell.swift
//  Travellers
//
//  Created by admin on 06.05.2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class TravellersTableViewCell: UITableViewCell {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    var travellerCell: TravellerModel? {
        didSet {
            userLabel.text = travellerCell?.user
            cityLabel.text = travellerCell?.city
        }
    }
}
