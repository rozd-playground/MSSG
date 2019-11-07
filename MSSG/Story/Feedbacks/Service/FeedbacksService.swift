//
//  FeedbacksService.swift
//  MSSG
//
//  Created by Max Rozdobudko on 06.11.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import ReactiveSwift
import TextileCore

protocol FeedbacksService {

    func list(for contact: ContactModel) -> SignalProducer<[Feedback], NSError>

    func rate(contact: ContactModel, withFeedback feedback: Feedback) -> SignalProducer<(), NSError>

    func create(feedback: Feedback) -> SignalProducer<(), NSError>
}

class TextileFeedbacksService: TextileService, FeedbacksService {

    func list(for contact: ContactModel) -> SignalProducer<[Feedback], NSError> {
        let textile = getTextileInstance()

        guard let thread = try? getThread(for: contact) else {
            return .empty
        }

        var error: NSError?
        let list = textile.files.list(thread.id_p, offset: nil, limit: 100, error: &error)
        if let error = error {
            return .init(error: error)
        }

        let files = list.itemsArray.compactMap { $0 as? TextileCore.Files }.compactMap { $0.filesArray.firstObject as? TextileCore.File }

        return feedbacks(from: files)
    }

    func rate(contact: ContactModel, withFeedback feedback: Feedback) -> SignalProducer<(), NSError> {
        let textile = getTextileInstance()
        return SignalProducer { [weak self] sink, lifecycle in
            guard let self = self else {
                return
            }

            let thread: TextileCore.Thread
            do { thread = try self.getOrCreateThread(for: contact) } catch let error as NSError {
                sink.send(error: error)
                return
            }

            let data: Data
            do { data = try JSONEncoder().encode(feedback) } catch let error as NSError {
                sink.send(error: error)
                return
            }

            textile.files.addData(data.base64EncodedString(), threadId: thread.id_p, caption: "Rated by `Current.user.name`") { (block, error) in
                guard let block = block else {
                    sink.send(error: NSError(domain: "MSSG.Textil", code: 0, error: error))
                    return
                }
                print("feedback created in block \(block)")
                sink.send(value: ())
                sink.sendCompleted()
            }

        }
    }

    func create(feedback: Feedback) -> SignalProducer<(), NSError> {
        return SignalProducer { sink, lifetime in
            print("creating feedback \(feedback)")
        }
    }

}

// MARK: Thread Helpers

extension TextileFeedbacksService {

    fileprivate func getThread(for contact: ContactModel) throws -> TextileCore.Thread? {
        let textile = getTextileInstance()

        var error: NSError?
        let list = textile.threads.list(&error)
        if let error = error {
            throw error
        }

        let key = TextileCore.Thread.keyForFeedbackThread(for: contact)

        return list.itemsArray.compactMap { $0 as? TextileCore.Thread }.first { $0.key == key }
    }

    fileprivate func createThread(for contact: ContactModel) throws -> TextileCore.Thread {
        let textile = getTextileInstance()

        let schema = AddThreadConfig_Schema()
        schema.preset = .blob

        let config = AddThreadConfig()
        config.key = TextileCore.Thread.keyForFeedbackThread(for: contact)
        config.name = "\(contact.nameForDisplay)'s Feedbacks"
        config.schema = schema
        config.sharing = .shared
        config.type = .open

        var error: NSError?
        let thread = textile.threads.add(config, error: &error)
        if let error = error {
            throw error
        }

        return thread
    }

    fileprivate func getOrCreateThread(for contact: ContactModel) throws -> TextileCore.Thread {
        return try getThread(for: contact) ?? createThread(for: contact)
    }

}

// MARK: - File Helpers

extension TextileFeedbacksService {

    func feedbacks(from files: [TextileCore.File]) -> SignalProducer<[Feedback], NSError> {
        return SignalProducer(value: files).flatten().flatMap(.merge) { file in
            return self.feedback(from: file)
        }.collect()
    }

    func feedback(from file: TextileCore.File) -> SignalProducer<Feedback, NSError> {
        let textile = getTextileInstance()
        return SignalProducer { sink, lifetime in
            textile.files.content(file.file.hash_p) { (data, caption, error) in
                guard let data = data else {
                    sink.send(error: NSError(domain: "MSSG.Textil", code: 0, error: error))
                    return
                }

                let feedback: Feedback
                do { feedback = try JSONDecoder().decode(Feedback.self, from: data)} catch let error as NSError {
                    sink.send(error: error)
                    return
                }

                sink.send(value: feedback)
                sink.sendCompleted()
            }
        }
    }

}

// MARK: - Serialization

extension Feedback {

    init?(from file: TextileCore.File) {
        return nil
    }
}
