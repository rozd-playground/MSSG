//
//  Current+User.swift
//  MSSG
//
//  Created by Max Rozdobudko on 29.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation

// MARK: - Current User

extension Current {
    static let user = Current.User()

    class User {

        init() {

        }

    }

}

// MARK: - Authorizable User

protocol AuthorizableUser {
    var isAuthenticated: Bool { get }
}

extension Current.User: AuthorizableUser {

    var isAuthenticated: Bool {
        return false
    }

}

// MARK: - Notification Center Extension

extension Notification.Name {
    static let userSignIn  = Notification.Name(rawValue: "userSignIn")
    static let userSignOut = Notification.Name(rawValue: "userSignOut")
}
