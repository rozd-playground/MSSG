//
//  NSError+Error.swift
//  MSSG
//
//  Created by Max Rozdobudko on 05.11.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation

extension NSError {

    convenience init(domain: String, code: Int, error: Error) {
        self.init(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])
    }

    convenience init(domain: String, code: Int, error: Error?, defaultLocalizedDescription localizedDescription: String) {
        guard let error = error else {
            self.init(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
            return
        }
        self.init(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])
    }

}
