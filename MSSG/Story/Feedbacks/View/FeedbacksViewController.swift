//
//  FeedbacksViewController.swift
//  MSSG
//
//  Created by Max Rozdobudko on 06.11.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class FeedbacksViewController: UIViewController, SegueHandler {

    enum SegueIdentifier: String {
        case showCreateFeedback
    }

    // MARK: Outlets

    @IBOutlet fileprivate weak var addFeedbackButton: UIButton!

    // MARK: View model

    var viewModel: FeedbacksViewModel!

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // reactive

        viewModel.refresh.apply().start()
    }
    
    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue: segue) {
        case .showCreateFeedback:
            if let vc = segue.destination as? CreateFeedbackViewController {
                vc.viewModel = viewModel.createCreateFeedbackViewModel()
            }
        }
    }

    // MARK: Actions

    @IBAction func handleCreateFeedbackButtonTap(_ sender: Any?) {
        performSegue(withIdentifier: .showCreateFeedback, sender: nil)
    }

}
