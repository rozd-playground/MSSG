//
//  TextileService.swift
//  MSSG
//
//  Created by Max Rozdobudko on 29.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import Textile
import ReactiveSwift

class TextileService {

    let textile: Textile

    let notifications = TextileNotificationCenter.center

    lazy var textileRepoPath: String = {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        return (documentPath as NSString).appendingPathComponent("textile-repo")
    }()

    init() {
        self.textile = Textile.instance()
    }
}

class TextileNotificationCenter: NSObject {
    static let center = TextileNotificationCenter()

    override init() {
        super.init()
        Textile.instance().delegate = self
    }

    fileprivate var contactQueries: [String: Signal<Contact, NSError>.Observer] = [:]
    func subscribeToContactQueries(_ queryId: String) -> Signal<Contact, NSError> {
        let (signal, observer) = Signal<Contact, NSError>.pipe()
        self.contactQueries[queryId] = observer
        signal.observeCompleted { [unowned self] in
            self.contactQueries.removeValue(forKey: queryId)
        }
        return signal
    }
}

// MARK: - TextileDelegate

extension TextileNotificationCenter: TextileDelegate {

    func queryDone(_ queryId: String) {
        guard let observer = contactQueries[queryId] else {
            return
        }
        observer.sendCompleted()
    }

    func contactQueryResult(_ queryId: String, contact: Contact) {
        guard let observer = contactQueries[queryId] else {
            return
        }
        observer.send(value: contact)
    }

    private func queryError(_ queryId: String, error: Error) {
        guard let observer = contactQueries[queryId] else {
            return
        }
        observer.send(error: NSError(domain: "MSSG.Textile", code: Int(error.code), userInfo: [NSLocalizedDescriptionKey : error.message ?? "Unknown Query Error"]))
    }
}
