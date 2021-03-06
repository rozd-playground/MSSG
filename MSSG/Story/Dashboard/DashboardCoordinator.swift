//
//  DashboardCoordinator.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit

class DashboardCoordinator: BaseCoordinator<()> {

    // MARK: Properties

    fileprivate let window: UIWindow

    fileprivate let viewModel: DashboardViewModel

    // MARK: Lifecycle

    init(window: UIWindow, viewModel: DashboardViewModel) {
        self.window = window
        self.viewModel = viewModel
    }

    // MARK: Entry point

    override func start(with completion: @escaping (()) -> ()) {
        var token: NSObjectProtocol!
        token = NotificationCenter.default.addObserver(forName: .userSignOut, object: nil, queue: OperationQueue.main) { notification in
            NotificationCenter.default.removeObserver(token!)
            completion(())
        }
        let rootViewController = UIStoryboard.dashboard.instantiateInitialViewController(with: viewModel)
        window.rootViewController = rootViewController
    }
    
}
