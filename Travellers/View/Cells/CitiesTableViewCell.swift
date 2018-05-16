//
//  CitiesTableViewCell.swift
//  Travellers
//
//  Created by admin on 06.05.2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class CitiesTableViewCell: UITableViewCell {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    var cityCell: CityModel? {
        didSet {
            cityLabel.text = cityCell?.name
            userIdLabel.text = "\(cityCell?.userId ?? 0)"
        }
    }
}
