//
//  Textile+MSSG.swift
//  MSSG
//
//  Created by Max Rozdobudko on 07.11.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import TextileCore

extension TextileCore.Thread {

    class func keyForFeedbackThread(for contact: ContactModel) -> String {
        return "com.github.rozd.playground.MSSG.v0.thread.feedback.contact.\(contact.address)"
    }

}
