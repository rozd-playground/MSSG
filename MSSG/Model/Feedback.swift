//
//  Feedback.swift
//  MSSG
//
//  Created by Max Rozdobudko on 06.11.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation

struct Feedback {
    let rating: Float
    let description: String?
}

extension Feedback {
    var ratingForDisplay: String {
        return "\(rating)★"
    }
}
