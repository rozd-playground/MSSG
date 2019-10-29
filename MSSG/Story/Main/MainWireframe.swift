//
//  MainWireframe.swift
//  RYAH
//
//  Created by Max Rozdobudko on 3/1/19.
//  Copyright © 2019 RYAH MEDTECH INC. All rights reserved.
//

import UIKit

// MARK: Dependency Injection

protocol MainAssembler {

}

extension MainAssembler {



}


// MARK: Storyboard Integration

extension UIStoryboard {
    class var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }

    func instantiateMainController() -> UINavigationController? {
        return UIStoryboard.main.instantiateInitialViewController() as? UINavigationController
    }

}
