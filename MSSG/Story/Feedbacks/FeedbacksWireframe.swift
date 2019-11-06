//
//  FeedbacksWireframe.swift
//  MSSG
//
//  Created by Max Rozdobudko on 06.11.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit

// MARK: Dependency Injection

protocol FeedbacksAssembler {
    func resolve() -> FeedbacksService
}

extension FeedbacksAssembler {

    func resolve() -> FeedbacksService {
        return TextileFeedbacksService()
    }

}

extension DefaultAssembler: FeedbacksAssembler {
    
}

// MARK: Storyboard Integration

extension UIStoryboard {

    class var feedbacks: UIStoryboard {
        return UIStoryboard(name: "Feedbacks", bundle: nil)
    }

}
