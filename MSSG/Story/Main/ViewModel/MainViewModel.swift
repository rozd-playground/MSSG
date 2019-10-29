//
//  MainViewModel.swift
//  MSSG
//
//  Created by Max Rozdobudko on 29.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation

class MainViewModel {

}

// MARK: - Nested view models

extension MainViewModel {

    func createAuthViewModel() -> AuthViewModel {
        return AuthViewModel()
    }
    
    func createDashboardViewModel() -> DashboardViewModel {
        return DashboardViewModel()
    }

}
