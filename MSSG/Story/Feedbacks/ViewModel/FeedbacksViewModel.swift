//
//  FeedbacksViewModel.swift
//  MSSG
//
//  Created by Max Rozdobudko on 06.11.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import ReactiveSwift

class FeedbacksViewModel {

    // MARK: Model

    fileprivate let feedbacks: Feedbacks

    fileprivate let contact: ContactModel

    // MARK: Outputs

    let list: Property<[Feedback]>

    let refresh: Action<(), [Feedback], NSError>

    // MARK: Lifecycle

    init(feedbacks: Feedbacks, contact: ContactModel) {
        self.feedbacks = feedbacks
        self.contact = contact

        refresh = Action {
            return feedbacks.list(for: contact)
        }

        list = Property(initial: [], then: refresh.values)
    }

}

// MARK: Table support

extension FeedbacksViewModel {

    var numberOfSections: Int {
        return 1
    }

    func numberOfRows(in section: Int) -> Int {
        return list.value.count
    }

    func feedback(at indexPath: IndexPath) -> Feedback {
        return list.value[indexPath.row]
    }

}

// MARK: Nested view models

extension FeedbacksViewModel {

    func createCreateFeedbackViewModel() -> CreateFeedbackViewModel {
        return CreateFeedbackViewModel(contact: contact)
    }

}
