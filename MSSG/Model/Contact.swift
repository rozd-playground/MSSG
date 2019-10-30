//
//  Contact.swift
//  MSSG
//
//  Created by Max Rozdobudko on 30.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation

struct ContactModel {
    let address: String
    let name: String

    init(address: String, name: String) {
        self.address = address
        self.name = name
    }
}
