//
//  CreateFeedbackViewModel.swift
//  MSSG
//
//  Created by Max Rozdobudko on 06.11.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import ReactiveSwift

class CreateFeedbackViewModel {

    // MARK: Model

    fileprivate let feedbacks: Feedbacks

    fileprivate let contact: ContactModel

    // MARK: Outputs

    var feedback: MutableProperty<Feedback?>

    // MARK: Input

    let create: Action<Feedback, (), NSError>

    // MARK: Lifecycle

    init(feedbacks: Feedbacks, contact: ContactModel) {
        self.feedbacks = feedbacks
        self.contact = contact

        feedback = MutableProperty(nil)

        create = Action { feedback in
            return feedbacks.create(feedback: feedback)
        }
    }

}
