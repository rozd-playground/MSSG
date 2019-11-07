//
//  Feedback.swift
//  MSSG
//
//  Created by Max Rozdobudko on 06.11.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation

struct Feedback: Codable {
    let rating: Float
    let detail: String?
}

extension Feedback {
    var ratingForDisplay: String {
        return "\(rating)★"
    }
}
