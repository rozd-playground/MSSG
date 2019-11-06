//
//  DashboardViewModel.swift
//  MSSG
//
//  Created by Max Rozdobudko on 29.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import ReactiveSwift

class DashboardViewModel {

    // MARK: Output

    let signOut: Action<(), (), NSError>

    // MARK: Lifecycle

    init() {
        signOut = Action {
            return Current.user.signOut()
        }
    }
    
}

// MARK: Nested view models

extension DashboardViewModel {

    func createContactsViewModel() -> ContactsViewModel {
        return ContactsViewModel()
    }

}
