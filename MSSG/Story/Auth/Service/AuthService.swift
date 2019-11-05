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

        var error: NSError?
        Textile.instance().account.sync(QueryOptions(), error: &error)
        if let error = error {
            print(error.localizedDescription)
        }

        return true
    }

    func signIn(recoveryPhrase phrase: String) -> SignalProducer<String, NSError> {
        return SignalProducer { [weak self] sink, disposable in
            guard let self = self else {
                return
            }
            guard !Textile.isInitialized(self.textileRepoPath) else {
                sink.send(error: NSError(domain: "MSSG.Textile", code: 0, userInfo: [NSLocalizedDescriptionKey : "Textile repo already exists."]))
                return
            }

            var error: NSError?
            let account = Textile.walletAccount(at: phrase, index: 0, password: nil, error: &error)
            if let error = error {
                sink.send(error: error)
                return
            }

            do {
                try Textile.initialize(self.textileRepoPath, seed: account.seed, debug: false, logToDisk: false)
            } catch let error as NSError {
                sink.send(error: error)
            }

            sink.send(value: account.address)
            sink.sendCompleted()
        }
    }

    func signUp() -> SignalProducer<String, NSError> {
        return SignalProducer { [weak self] sink, disposable in
            guard let self = self else {
                return
            }
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
