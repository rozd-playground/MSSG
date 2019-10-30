//
//  ContactSearchViewModel.swift
//  MSSG
//
//  Created by Max Rozdobudko on 30.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import ReactiveSwift

class ContactSearchViewModel {

    // MARK: Model

    fileprivate let contacts: Contacts

    // MARK: Outputs

    var query: MutableProperty<String?>

    let results: Property<[ContactModel]>

    // MARK: Inputs

    let search: Action<(), [ContactModel], NSError>

    let add: Action<ContactModel, (), NSError>

    // MARK: Lifecycle

    init(contacts: Contacts) {
        self.contacts = contacts

        query = MutableProperty(nil)

        search = Action(unwrapping: query, execute: { name in
            return contacts.search(byName: name)
        })

        add = Action { contact in
            return contacts.add(contact: contact)
        }

        results = Property(initial: [], then: search.values)
    }
}

// MARK: Table Support

extension ContactSearchViewModel {

    var numberOfSections: Int {
        return 1
    }

    func numberOfRows(in section: Int) -> Int {
        return results.value.count
    }

    func contact(at indexPath: IndexPath) -> ContactModel {
        return results.value[indexPath.row]
    }

}
