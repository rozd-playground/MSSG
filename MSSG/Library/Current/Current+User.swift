//
//  Current+User.swift
//  MSSG
//
//  Created by Max Rozdobudko on 29.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import ReactiveSwift

// MARK: - Current User

extension Current {
    static let user = Current.User()

    class User {
        fileprivate let service: AuthService

        init(service: AuthService) {
            self.service = service
        }

    }

}

// MARK: - Authorizable User

protocol AuthorizableUser {
    var isAuthenticated: Bool { get }
    func signIn(recoveryPhrase phrase: String) -> SignalProducer<String, NSError>
    func signUp() -> SignalProducer<String, NSError>
    func signOut() -> SignalProducer<(), NSError>
}

extension Current.User: AuthorizableUser {

    var isAuthenticated: Bool {
        return service.isAuthenticated
    }

    func signIn(recoveryPhrase phrase: String) -> SignalProducer<String, NSError> {
        return service.signIn(recoveryPhrase: phrase).on(value: { _ in
            NotificationCenter.default.post(Notification(name: .userSignIn))
        })
    }

    func signUp() -> SignalProducer<String, NSError> {
        return service.signUp().on(value: { _ in
            NotificationCenter.default.post(Notification(name: .userSignIn))
        })
    }

    func signOut() -> SignalProducer<(), NSError> {
        return service.signOut().on(value: { _ in
            NotificationCenter.default.post(Notification(name: .userSignOut))
        })
    }
    
}

// MARK: - Notification Center Extension

extension Notification.Name {
    static let userSignIn  = Notification.Name(rawValue: "userSignIn")
    static let userSignOut = Notification.Name(rawValue: "userSignOut")
}
