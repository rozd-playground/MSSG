//
//  DashboardViewController.swift
//  MSSG
//
//  Created by Max Rozdobudko on 29.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class DashboardViewController: UIViewController, SegueHandler {

    enum SegueIdentifier: String {
        case showContacts
    }

    // MARK: Outlets

    @IBOutlet fileprivate weak var signOutButton: UIBarButtonItem!
    
    @IBOutlet fileprivate weak var contactsButton: DesignButton!

    // MARK: View model

    var viewModel: DashboardViewModel!

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // reactive

        signOutButton.reactive.pressed = CocoaAction(viewModel.signOut)
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segueIdentifierForSegue(segue: segue)) {
        case .showContacts:
            if let destination = segue.destination as? ContactsViewController {
                destination.viewModel = viewModel.createContactsViewModel()
            }
        }
    }

    // MARK: Actions

    @IBAction func handleContactsButtonTap(_ sender: Any) {
        performSegue(withIdentifier: .showContacts, sender: nil)
    }
}
