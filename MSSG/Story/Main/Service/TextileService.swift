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
import TextileCore

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

    // MARK: Node

    func nodeStarted() {
        print("TextileDelegate.nodeStarted")
    }

    func nodeStopped() {
        print("TextileDelegate.nodeStopped")
    }

    func nodeOnline() {
        print("TextileDelegate.nodeOnline")
    }

    private func nodeFailedToStopWithError(_ error: Error) {
        print("TextileDelegate.nodeFailedToStopWithError(\(String(describing: error)))")
    }

    private func nodeFailedToStartWithError(_ error: Error) {
        print("TextileDelegate.nodeFailedToStartWithError(\(error)))")
    }

    func willStopNodeInBackground(afterDelay seconds: TimeInterval) {
        print("TextileDelegate.willStopNodeInBackground(afterDelay \(seconds))")
    }

    func canceledPendingNodeStop() {
        print("TextileDelegate.willStopNodeInBackground")
    }

    // MARK: Account

    func accountPeerAdded(_ peerId: String) {
        print("TextileDelegate.accountPeerAdded(\(peerId))")
    }

    func accountPeerRemoved(_ peerId: String) {
        print("TextileDelegate.accountPeerRemoved(\(peerId))")
    }

    // MARK: Notifications

    func notificationReceived(_ notification: TextileCore.Notification) {
        print("TextileDelegate.notificationReceived(\(notification))")
    }

    // MARK: Queries

    func queryDone(_ queryId: String) {
        guard let observer = contactQueries[queryId] else {
            return
        }
        observer.sendCompleted()
    }

    private func queryError(_ queryId: String, error: Error) {
        guard let observer = contactQueries[queryId] else {
            return
        }
        observer.send(error: NSError(domain: "MSSG.Textile", code: Int(error.code), userInfo: [NSLocalizedDescriptionKey : error.message ?? "Unknown Query Error"]))
    }

    // MARK: Contacts

    func contactQueryResult(_ queryId: String, contact: Contact) {
        guard let observer = contactQueries[queryId] else {
            return
        }
        observer.send(value: contact)
    }

    // MARK: Thread

    func threadAdded(_ threadId: String) {
        print("TextileDelegate.threadAdded(\(threadId))")
    }

    func threadRemoved(_ threadId: String) {
        print("TextileDelegate.threadRemoved(\(threadId))")
    }

    func threadUpdateReceived(_ threadId: String, data feedItemData: FeedItemData) {
        print("TextileDelegate.threadUpdateReceived(\(threadId), \(feedItemData))")
    }

    func clientThreadQueryResult(_ queryId: String, thread: TextileCore.Thread) {
        print("TextileDelegate.clientThreadQueryResult(\(queryId), \(thread))")
    }

    // MARK: Sync

    func syncFailed(_ status: CafeSyncGroupStatus) {
        print("TextileDelegate.syncFailed(\(status))")
    }

    func syncUpdate(_ status: CafeSyncGroupStatus) {
        print("TextileDelegate.syncUpdate(\(status)")
    }

    func syncComplete(_ status: CafeSyncGroupStatus) {
        print("TextileDelegate.syncComplete(\(status))")
    }

}
