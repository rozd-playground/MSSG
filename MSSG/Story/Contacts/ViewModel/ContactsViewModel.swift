//
//  ContactsViewModel.swift
//  MSSG
//
//  Created by Max Rozdobudko on 30.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import ReactiveSwift

class ContactsViewModel {

    // MARK: Model

    fileprivate let contacts: Contacts

    // MARK: Outputs

    let myContacts: Property<[ContactModel]>

    // MARK: Inputs

    let refresh: Action<(), [ContactModel], NSError>

    // MARK: Lifecycle

    init(contacts: Contacts) {
        self.contacts = contacts

        refresh = Action {
            return contacts.list()
        }

        myContacts = Property(initial: [], then: refresh.values)
    }
}

// MARK: Table support

extension ContactsViewModel {

    var numberOfSections: Int {
        return 1
    }

    func numberOfRows(in section: Int) -> Int {
        return myContacts.value.count
    }

    func contact(at indexPath: IndexPath) -> ContactModel {
        return myContacts.value[indexPath.row]
    }
    
}

// MARK: Nested view models

extension ContactsViewModel {

    func createContactSearchViewModel() -> ContactSearchViewModel {
        return ContactSearchViewModel(contacts: contacts)
    }

    func createFeedbacksViewModel(for contact: ContactModel) -> FeedbacksViewModel {
        return FeedbacksViewModel(contact: contact)
    }
    
}
