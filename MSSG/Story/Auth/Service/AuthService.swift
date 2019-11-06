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

    func signOut() -> SignalProducer<(), NSError>
}

class TextileAuthService: TextileService, AuthService {

    var isAuthenticated: Bool {
        let repoPath = self.getTextileRepoPath()

        guard Textile.isInitialized(repoPath) else {
            return false
        }

        do {
            try Textile.launch(repoPath, debug: true)
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
        let repoPath = self.getTextileRepoPath()
        return SignalProducer { sink, lifetime in
            guard !Textile.isInitialized(repoPath) else {
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
                try Textile.initialize(repoPath, seed: account.seed, debug: false, logToDisk: false)
            } catch let error as NSError {
                sink.send(error: error)
            }

            sink.send(value: account.address)
            sink.sendCompleted()
        }
    }

    func signUp() -> SignalProducer<String, NSError> {
        let repoPath = self.getTextileRepoPath()

        return SignalProducer { sink, lifetime in
            guard !Textile.isInitialized(repoPath) else {
                sink.send(error: NSError(domain: "MSSG.Textile", code: 0, userInfo: [NSLocalizedDescriptionKey : "Textile repo already exists."]))
                return
            }

            var error: NSError?
            let recoveryPhrase = Textile.initializeCreatingNewWalletAndAccount(repoPath, debug: false, logToDisk: false, error: &error)

            if let error = error {
                sink.send(error: error)
            } else {
                sink.send(value: recoveryPhrase)
                sink.sendCompleted()
            }
        }
    }

    func signOut() -> SignalProducer<(), NSError> {
        let textile = getTextileInstance()
        let repoPath = getTextileRepoPath()
        return SignalProducer { sink, lifetime in
            textile.destroy { success, error in
                guard success else {
                    sink.send(error: NSError(domain: "MMSG.Textile", code: 0, error: error, defaultLocalizedDescription: "Unknown error during destroying a Textile instance."))
                    return
                }

                do {
                    try FileManager.default.removeItem(atPath: repoPath)
                } catch let error {
                    sink.send(error: NSError(domain: "MSSG.Textile", code: 0, error: error))
                    return
                }

                sink.send(value: ())
                sink.sendCompleted()
            }
        }
    }
}
