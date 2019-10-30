//
//  UIKit+Extensions.swift
//  MSSG
//
//  Created by Max Rozdobudko on 29.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit

// MARK: ViewController

extension UIViewController {

    class var storyboardIdentifier: String {
        return String(describing: self)
    }

    class func instantiate(from storyboard: UIStoryboard) -> Self {
        return instantiateViewController(of: self, from: storyboard)
    }

    class func instantiate(fromStoryboardWithName name: String) -> Self {
        return instantiate(from: UIStoryboard(name: name, bundle: nil))
    }

    private class func instantiateViewController<T: UIViewController>(of type: T.Type, from storyboard: UIStoryboard) -> T {
        if let controller = storyboard.instantiateViewController(withIdentifier: type.storyboardIdentifier) as? T {
            return controller
        } else {
            return T()
        }
    }

}

extension UIViewController {

    static func topViewController(_ viewController: UIViewController) -> UIViewController {
        guard let presentedViewController = viewController.presentedViewController else {
            return viewController
        }
        if let navigationController = presentedViewController as? UINavigationController {
            if let visibleViewController = navigationController.visibleViewController {
                return topViewController(visibleViewController)
            }
        } else if let tabBarController = presentedViewController as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                return topViewController(selectedViewController)
            }
        }
        return topViewController(presentedViewController)
    }

}

extension UIViewController {

    func showAlert(withTitle title: String?, message: String?) {
        showAlert(withTitle: title, message: message, handler: nil)
    }

    func showAlert(withTitle title: String?, message: String?, handler: ((UIAlertAction) -> ())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: handler)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func showAlert(withError error: Error, handler: ((UIAlertAction) -> ())? = nil) {
        showAlert(withTitle: "Error", message: error.localizedDescription, handler: handler)
    }

}

// MARK: UITableView


// MARK: - UITableView extenstions

extension UITableView {

    func register<T: UITableViewCell>(nib: UINib, forCellWithType type: T.Type) {
        register(nib, forCellReuseIdentifier: type.reusableIdentifier)
    }

    func register<T: UITableViewCell>(nibForCellWithType type: T.Type) {
        let nib = UINib(nibName: type.reusableIdentifier, bundle: nil)
        register(nib: nib, forCellWithType: type)
    }

    func dequeueReusableCell<T: UITableViewCell>(withType type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: type.reusableIdentifier, for: indexPath) as! T
    }

    func registerDefaultReusableCell() {
        register(UITableViewCell.self, forCellReuseIdentifier: "defaultReusableCell")
    }

    func dequeueDefaultReusableCell() -> UITableViewCell {
        return dequeueReusableCell(withIdentifier: "defaultReusableCell") ?? UITableViewCell(style: .default, reuseIdentifier: "defaultReusableCell")
    }

    func lastSectionIndex() -> Int {
        return numberOfSections - 1
    }

    func lastRowIndex(inSection section: Int) -> Int {
        return numberOfRows(inSection: section) - 1
    }

}

// MARK: - UITableViewCell extenstions

extension UITableViewCell {

    class var reusableIdentifier: String {
        return String(describing: self)
    }

    class func nib(bundle: Bundle? = nil) -> UINib {
        return UINib(nibName: reusableIdentifier, bundle: bundle)
    }

}

