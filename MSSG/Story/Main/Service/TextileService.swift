//
//  TextileService.swift
//  MSSG
//
//  Created by Max Rozdobudko on 29.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import Textile

class TextileService {

    let textile: Textile

    lazy var textileRepoPath: String = {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        return (documentPath as NSString).appendingPathComponent("textile-repo")
    }()

    init() {
        self.textile = Textile.instance()
    }
}
