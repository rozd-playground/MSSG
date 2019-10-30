//
//  MSSG.swift
//  MSSG
//
//  Created by Max Rozdobudko on 29.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation

class MSSG {

    // MARK: Models

    let auth: Auth

    let contacts: Contacts

    // MARK: Lifecycle

    init(auth: Auth, contacts: Contacts) {
        self.auth = auth
        self.contacts = contacts
    }

}
