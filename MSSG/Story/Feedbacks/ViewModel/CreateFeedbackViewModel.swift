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

    fileprivate let feedback: Property<Feedback?>

    // MARK: Outputs



    // MARK: Input

    let rating: MutableProperty<Float?>

    let detail: MutableProperty<String?>

    let rate: Action<(), (), NSError>

    // MARK: Lifecycle

    init(feedbacks: Feedbacks, contact: ContactModel) {
        self.feedbacks = feedbacks
        self.contact = contact

        rating = MutableProperty(0.0)
        detail = MutableProperty(nil)

        feedback = Property.combineLatest(rating, detail).map { Feedback(rating: $0.0, detail: $0.1) }

        rate = Action(unwrapping: feedback) { feedback in
            return feedbacks.create(feedback: feedback)
        }
    }

}

extension Feedback {
    init?(rating: Float?, detail: String?) {
        guard let rating = rating else {
            return nil
        }
        self.init(rating: rating, description: detail)
    }
}
