//
//  DashboardWireframe.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit

// MARK: Dependency Injection

protocol DashboardAssembler {

}

extension DashboardAssembler {



}

// MARK: Storyboard Integration

extension UIStoryboard {

    class var dashboard: UIStoryboard {
        return UIStoryboard(name: "Dashboard", bundle: nil)
    }

    func instantiateInitialViewController(with viewModel: DashboardViewModel) -> UIViewController? {
        let initial = UIStoryboard.dashboard.instantiateInitialViewController()
        if let nc = initial as? UINavigationController, let dashboard = nc.topViewController as? DashboardViewController {
            dashboard.viewModel = viewModel
        }
        return initial
    }
    
}
