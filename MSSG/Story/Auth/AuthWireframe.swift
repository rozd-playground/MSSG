//
//  AuthWireframe.swift
//  RYAH
//
//  Created by Max Rozdobudko on 3/1/19.
//  Copyright © 2019 RYAH MEDTECH INC. All rights reserved.
//

import UIKit

// MARK: Dependency Injection

protocol AuthAssembler {
    func resolve() -> AuthService
}

extension AuthAssembler {

    func resolve() -> AuthService {
        return TextileAuthService()
    }

}

// MARK: Storyboard integration

extension UIStoryboard {
    class var auth: UIStoryboard {
        return UIStoryboard(name: "Auth", bundle: nil)
    }

    func instantiateInitialViewController(with viewModel: AuthViewModel) -> UIViewController? {
        let initial = UIStoryboard.auth.instantiateInitialViewController()
        if let vc = initial as? AuthViewController {
            vc.viewModel = viewModel
        }
        return initial
    }

}
