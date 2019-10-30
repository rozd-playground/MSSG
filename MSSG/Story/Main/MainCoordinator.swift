//
//  MainCoordinator.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit

class MainCoordinator: BaseCoordinator<()> {

    // MARK: Variables

    fileprivate let window: UIWindow

    fileprivate let viewModel: MainViewModel

    // MARK: Lifecycle

    init(window: UIWindow?, viewModel: MainViewModel) {
        guard let window = window else {
            fatalError("UIWindow is unavailable")
        }
        self.window = window
        self.viewModel  = viewModel
    }

    // MARK: Start point

    func start() {
        start {}
    }

    override func start(with completion: @escaping (()) -> ()) {
        guard Current.user.isAuthenticated else {
            showAuth { [weak self] in
                self?.start {}
            }
            return
        }

        showContacts { [weak self] in
            self?.start()
        }

//        showDashboard { [weak self] in
//            self?.start {}
//        }
    }

}

// MARK: - Navigation

extension MainCoordinator {

    func showAuth(completion: @escaping () -> ()) {
        let coordinator = AuthCoordinator(window: window, model: viewModel.createAuthViewModel())
        coordinate(to: coordinator, with: completion)
    }

    func showDashboard(completion: @escaping () -> ()) {
        let coordinator = DashboardCoordinator(window: window, viewModel: viewModel.createDashboardViewModel())
        coordinate(to: coordinator, with: completion)
    }

    func showContacts(completion: @escaping () -> ()) {
        let coordinator = ContactsCoordinator(window: window, viewModel: viewModel.createContactsViewModel())
        coordinate(to: coordinator, with: completion)
    }

}
