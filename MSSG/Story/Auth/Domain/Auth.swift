//
//  Auth.swift
//  MSSG
//
//  Created by Max Rozdobudko on 29.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import ReactiveSwift

class Auth {

    // MARK: Dependencies

    fileprivate let service: AuthService

    // MARK: Lifecycle

    init(service: AuthService) {
        self.service = service
    }

    // MARK: Sign Up

    func signUp() -> SignalProducer<String, NSError> {
        return service.signUp()
    }

}
