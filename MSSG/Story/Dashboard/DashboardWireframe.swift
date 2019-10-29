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

    class var Dashboard: UIStoryboard {
        return UIStoryboard(name: "Dashboard", bundle: nil)
    }

    func instantiateInitialViewController(with viewModel: DashboardViewModel) -> UIViewController? {
        guard let vc = UIStoryboard.Dashboard.instantiateInitialViewController() as? DashboardViewController else {
            fatalError("Initial view controller for Dashboard storyboard should be of DashboardViewController type.")
        }
        vc.viewModel = viewModel
        return vc
    }
    
}
