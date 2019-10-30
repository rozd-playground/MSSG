//
//  Contacts.swift
//  MSSG
//
//  Created by Max Rozdobudko on 30.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import ReactiveSwift

class Contacts {

    // MARK: Dependencies

    fileprivate let service: ContactsService

    // MARK: Lifecycle

    init(service: ContactsService) {
        self.service = service
    }

    // MARK: Search

    func list() -> SignalProducer<[ContactModel], NSError> {
        return service.list()
    }
    
    func search(byName name: String) -> SignalProducer<[ContactModel], NSError> {
        return service.search(byName: name)
    }

    func add(contact: ContactModel) -> SignalProducer<(), NSError> {
        return service.add(contact: contact)
    }

}
