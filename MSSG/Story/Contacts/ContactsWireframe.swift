//
//  ContactsWireframe.swift
//  MSSG
//
//  Created by Max Rozdobudko on 30.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit

// MARK: Dependency Injection

protocol ContactsAssembler {
    func resolve() -> ContactsService
}

extension ContactsAssembler {

    func resolve() -> ContactsService {
        return TextileContactsService()
    }

}

// MARK: Storyboard Integration

extension UIStoryboard {

    class var contacts: UIStoryboard {
        return UIStoryboard(name: "Contacts", bundle: nil)
    }

    func instantiateInitialViewController(with viewModel: ContactsViewModel) -> UIViewController? {
        let initial = UIStoryboard.contacts.instantiateInitialViewController()
        if let nc = initial as? UINavigationController, let contacts = nc.topViewController as? ContactsViewController {
            contacts.viewModel = viewModel
        }
        return initial
    }

}
