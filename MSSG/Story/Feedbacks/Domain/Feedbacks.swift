//
//  File.swift
//  MSSG
//
//  Created by Max Rozdobudko on 06.11.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import ReactiveSwift

class Feedbacks {

    // MARK: Dependencies

    fileprivate let service: FeedbacksService

    // MaRK: Lifecycle

    init(service: FeedbacksService) {
        self.service = service
    }

    // MARK: Methods

    func list(for contact: ContactModel) -> SignalProducer<[Feedback], NSError> {
        return service.list(for: contact)
    }

    func rate(contact: ContactModel, withFeedback feedback: Feedback) -> SignalProducer<(), NSError> {
        return service.rate(contact: contact, withFeedback: feedback)
    }
    
}
