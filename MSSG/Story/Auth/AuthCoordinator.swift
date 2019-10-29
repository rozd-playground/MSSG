//
//  AuthCoordinator.swift
//  MSSG
//
//  Created by Max Rozdobudko on 29.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit

class AuthCoordinator: BaseCoordinator<()> {

    private let window: UIWindow
    private let model: AuthViewModel

    init(window: UIWindow, model: AuthViewModel) {
        self.window = window
        self.model  = model
    }

    override func start(with completion: @escaping (()) -> ()) {
        var token: NSObjectProtocol!
        token = NotificationCenter.default.addObserver(forName: .userSignIn, object: nil, queue: OperationQueue.main) { notification in
            NotificationCenter.default.removeObserver(token!)
            completion(())
        }
        let rootViewController = UIStoryboard.auth.instantiateInitialViewController(with: model)
        window.rootViewController = rootViewController
    }

}
