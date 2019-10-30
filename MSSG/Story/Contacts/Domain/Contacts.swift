//
//  Contacts.swift
//  MSSG
//
//  Created by Max Rozdobudko on 30.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation

class Contacts {

    // MARK: Dependencies

    fileprivate let service: ContactsService

    // MARK: Lifecycle

    init(service: ContactsService) {
        self.service = service
    }
}
