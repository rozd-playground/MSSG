//
//  ContactsViewModel.swift
//  MSSG
//
//  Created by Max Rozdobudko on 30.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation

class ContactsViewModel {

    // MARK: Model

    fileprivate let contacts: Contacts

    // MARK: Lifecycle

    init(contacts: Contacts) {
        self.contacts = contacts
    }
}
