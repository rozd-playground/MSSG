//
//  ContactsCoordinator.swift
//  MSSG
//
//  Created by Max Rozdobudko on 30.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit

class ContactsCoordinator: BaseCoordinator<()> {

    // MARK: Properties

    fileprivate let window: UIWindow

    fileprivate let viewModel: ContactsViewModel

    // MARK: Lifecycle

    init(window: UIWindow, viewModel: ContactsViewModel) {
        self.window = window
        self.viewModel = viewModel
    }

    // MARK: Entry point

    override func start(with completion: @escaping (()) -> ()) {
        let rootViewController = UIStoryboard.contacts.instantiateInitialViewController(with: viewModel)
        window.rootViewController = rootViewController
    }

}
