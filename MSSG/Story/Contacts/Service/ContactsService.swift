//
//  ContactsService.swift
//  MSSG
//
//  Created by Max Rozdobudko on 30.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import ReactiveSwift
import Textile

protocol ContactsService {
    func list() -> SignalProducer<[ContactModel], NSError>
    func search(byName name: String) -> SignalProducer<[ContactModel], NSError>
    func add(contact: ContactModel) -> SignalProducer<(), NSError>
}

class TextileContactsService: TextileService, ContactsService {

    func list() -> SignalProducer<[ContactModel], NSError> {
        return SignalProducer { [unowned self] sink, disposable in
            var error: NSError?
            let contacts = self.textile.contacts.list(&error)
            if let error = error {
                sink.send(error: error)
            } else {
                let models = contacts.itemsArray.compactMap { $0 as? Contact }.map { ContactModel(from: $0) }
                sink.send(value: models)
                sink.sendCompleted()
            }
        }
    }

    func search(byName name: String) -> SignalProducer<[ContactModel], NSError> {
        return SignalProducer { [unowned self] sink, lifetime in
            let query = ContactQuery()
            query.name = name

            let options = QueryOptions()
            options.limit = 100

            var error: NSError?
            let handle = self.textile.contacts.search(query, options: options, error: &error)
            if let error = error {
                sink.send(error: error)
            }

            self.notifications.subscribeToContactQueries(handle.id_)
                .take(during: lifetime)
                .collect()
                .observeResult { result in
                    switch result {
                    case .success(let contacts):
                        sink.send(value: contacts.map { ContactModel(from: $0) })
                        sink.sendCompleted()
                    case .failure(let error):
                        sink.send(error: error)
                    }
                }

            lifetime.observeEnded {
                handle.cancel()
            }
        }
    }

    func add(contact: ContactModel) -> SignalProducer<(), NSError> {
        return SignalProducer { [unowned self] sink, disposable in
            var error: NSError?
            let contact = self.textile.contacts.get(contact.address, error: &error)
            if let error = error {
                sink.send(error: error)
                return
            }
            self.textile.contacts.add(contact, error: &error)
            if let error = error {
                sink.send(error: error)
            } else {
                sink.send(value: ())
                sink.sendCompleted()
            }
        }
    }
    
}

// MARK: - Serialization

extension ContactModel {

    init(from contact: Contact) {
        self.address = contact.address
        self.name = contact.name
    }
}
