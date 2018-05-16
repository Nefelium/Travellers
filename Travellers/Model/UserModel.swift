//
//  UserModel.swift
//  Travellers
//
//  Created by admin on 27.04.2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation

struct UserModel {
    
    let id: Int
    var name: String
    
    init(id: Int) {
        self.id = id
        name = ""
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
