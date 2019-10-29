//
//  Segues.swift
//  RYAH
//
//  Created by Max Rozdobudko on 3/1/19.
//  Copyright © 2019 RYAH MEDTECH INC. All rights reserved.
//

import Foundation
import UIKit

// MARK: SegueHandler

protocol SegueHandler {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandler where Self: UIViewController, SegueIdentifier.RawValue == String {

    func performSegue(withIdentifier segueIdentifier: SegueIdentifier, sender: Any?) {
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: sender)
    }

    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {

        guard let identifier = segue.identifier,
            let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
                fatalError("Unsupported segue identifier")
        }

        return segueIdentifier
    }

}

// MARK: Custom Segues

class ShowAndReplaceSegue: UIStoryboardSegue {

    override func perform() {
        guard let navigationController = self.source.navigationController else {
            super.perform()
            return
        }

        navigationController.pushViewController(self.destination, animated: true)
        var stack = navigationController.viewControllers
        stack.remove(at: stack.count - 2)
        navigationController.setViewControllers(stack, animated: false)
    }

}
