//
//  TravellerModel.swift
//  Travellers
//
//  Created by admin on 29.04.2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

struct TravellerModel {
    
    let id: Int
    var user: String
    var city: String
    
    init(id: Int) {
        self.id = id
        user = ""
        city = ""
    }
    
    init(id: Int, user: String) {
        self.id = id
        self.user = user
        city = ""
    }
    
    init(id: Int, user: String, city: String) {
        self.id = id
        self.user = user
        self.city = city
    }
    
}
