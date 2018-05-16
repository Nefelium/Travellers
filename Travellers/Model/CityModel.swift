//
//  CityModel.swift
//  Travellers
//
//  Created by admin on 27.04.2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

struct CityModel {
    
    let id: Int
    var name: String
    var userId: Int?
    
    init(id: Int) {
        self.id = id
        name = ""
        userId = nil
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
        userId = nil
    }
    
    init(id: Int, name: String, userId: Int) {
        self.id = id
        self.name = name
        self.userId = userId
    }
}
