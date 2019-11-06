//
//  FeedbacksService.swift
//  MSSG
//
//  Created by Max Rozdobudko on 06.11.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import ReactiveSwift
import Textile

protocol FeedbacksService {

    func list() -> SignalProducer<[Feedback], NSError>

    func create(feedback: Feedback) -> SignalProducer<(), NSError>
}

class TextileFeedbacksService: TextileService, FeedbacksService {

    func list() -> SignalProducer<[Feedback], NSError> {
        return SignalProducer { sink, lifetime in
            
        }
    }

    func create(feedback: Feedback) -> SignalProducer<(), NSError> {
        let textile = getTextileInstance()
        return SignalProducer { sink, lifetime in
            print("creating feedback \(feedback)")
        }
    }

}
