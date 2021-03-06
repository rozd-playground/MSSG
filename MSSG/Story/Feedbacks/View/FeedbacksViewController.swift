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

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var refreshBarButtonItem: UIBarButtonItem!

    @IBOutlet fileprivate weak var addFeedbackButton: UIButton!

    // MARK: View model

    var viewModel: FeedbacksViewModel!

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // tableView

        tableView.registerDefaultReusableCell()
        tableView.dataSource = self

        // reactive

        refreshBarButtonItem.reactive.pressed = CocoaAction(viewModel.refresh)

        viewModel.refresh.values
            .observe(on: UIScheduler())
            .take(duringLifetimeOf: self)
            .observeValues { [weak self] _ in
                self?.tableView.reloadData()
            }

        viewModel.refresh.errors
            .observe(on: UIScheduler())
            .take(duringLifetimeOf: self)
            .observeValues { [weak self] error in
                self?.showAlert(withError: error, handler: nil)
            }

        // refresh

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

// MARK: - UITableViewDataSource

extension FeedbacksViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueDefaultReusableCell()

        let feedback = viewModel.feedback(at: indexPath)
        cell.textLabel?.text = feedback.ratingForDisplay
        cell.detailTextLabel?.text = feedback.detail

        return cell
    }

}

// MARK: - UITableViewDelegate

extension FeedbacksViewController: UITableViewDelegate {

}
