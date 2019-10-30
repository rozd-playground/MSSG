//
//  MainViewModel.swift
//  MSSG
//
//  Created by Max Rozdobudko on 29.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation

class MainViewModel {

    // MARK: Model

    fileprivate let mssg: MSSG

    // MARK: Lifecycle

    init(mssg: MSSG) {
        self.mssg = mssg
    }
}

// MARK: - Nested view models

extension MainViewModel {

    func createAuthViewModel() -> AuthViewModel {
        return AuthViewModel(auth: mssg.auth)
    }
    
    func createDashboardViewModel() -> DashboardViewModel {
        return DashboardViewModel()
    }

    func createContactsViewModel() -> ContactsViewModel {
        return ContactsViewModel(contacts: mssg.contacts)
    }

}
