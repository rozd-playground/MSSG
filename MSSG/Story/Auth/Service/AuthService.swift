//
//  AuthService.swift
//  MSSG
//
//  Created by Max Rozdobudko on 29.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import ReactiveSwift
import Textile

protocol AuthService {

    var isAuthenticated: Bool { get }

    func signIn(recoveryPhrase phrase: String) -> SignalProducer<String, NSError>

    func signUp() -> SignalProducer<String, NSError>
}

class TextileAuthService: TextileService, AuthService {

    var isAuthenticated: Bool {
        guard Textile.isInitialized(self.textileRepoPath) else {
            return false
        }

        do {
            try Textile.launch(self.textileRepoPath, debug: true)
        } catch let e {
            print(e.localizedDescription)
            return false
        }

        return true
    }

    func signIn(recoveryPhrase phrase: String) -> SignalProducer<String, NSError> {
        return SignalProducer { sink, disposable in

        }
    }

    func signUp() -> SignalProducer<String, NSError> {
        return SignalProducer { sink, disposable in
            guard !Textile.isInitialized(self.textileRepoPath) else {
                sink.send(error: NSError(domain: "MSSG.Textile", code: 0, userInfo: [NSLocalizedDescriptionKey : "Textile repo already exists."]))
                return
            }

            var error: NSError?
            let recoveryPhrase = Textile.initializeCreatingNewWalletAndAccount(self.textileRepoPath, debug: false, logToDisk: false, error: &error)

            if let error = error {
                sink.send(error: error)
            } else {
                sink.send(value: recoveryPhrase)
                sink.sendCompleted()
            }
        }
    }
}
