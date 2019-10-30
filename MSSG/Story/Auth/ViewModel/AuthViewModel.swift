//
//  AuthViewModel.swift
//  MSSG
//
//  Created by Max Rozdobudko on 29.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import ReactiveSwift

class AuthViewModel {

    // MARK: Model

    fileprivate let auth: Auth

    // MARK: Outputs

    let recoveryPhrase: MutableProperty<String?>

    // MARK: Inputs

    let signUp: Action<(), String, NSError>

    let signIn: Action<(), String, NSError>

    // MARK: Lifecycle

    init(auth: Auth) {
        self.auth = auth

        recoveryPhrase = MutableProperty(nil)

        signUp = Action {
            return Current.user.signUp()
        }

        signIn = Action(unwrapping: recoveryPhrase, execute: { phrase in
            return Current.user.signIn(recoveryPhrase: phrase)
        })

    }
}
