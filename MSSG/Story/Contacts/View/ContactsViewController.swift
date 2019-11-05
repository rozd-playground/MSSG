//
//  ContactsViewController.swift
//  MSSG
//
//  Created by Max Rozdobudko on 30.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Textile

class ContactsViewController: UIViewController, SegueHandler {

    enum SegueIdentifier: String {
        case showContactSearch
    }

    // MARK: Outlets

    @IBOutlet weak var refreshBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var searchBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    // MARK: View model

    var viewModel: ContactsViewModel!

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // tableView

        tableView.registerDefaultReusableCell()
        tableView.dataSource = self
        tableView.delegate = self

        // reactive

        refreshBarButtonItem.reactive.pressed = CocoaAction(viewModel.refresh)

        viewModel.myContacts.signal
            .observe(on: UIScheduler())
            .take(duringLifetimeOf: self)
            .observeValues { [weak self] contacts in
                self?.tableView.reloadData()
            }

        viewModel.refresh.errors
            .observe(on: UIScheduler())
            .take(duringLifetimeOf: self)
            .observeValues { [weak self] error in
                self?.showAlert(withError: error)
            }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshContacts()
    }

    // MARK: Methods

    fileprivate func refreshContacts() {
        print("address: \(Textile.instance().account.address())")
        print("seed: \(Textile.instance().account.seed())")

        viewModel.refresh.apply(())
            .observe(on: UIScheduler())
            .take(duringLifetimeOf: self)
            .start()
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue: segue) {
        case .showContactSearch:
            if let vc = segue.destination as? ContactSearchViewController {
                vc.viewModel = viewModel.createContactSearchViewModel()
            }
        }
    }

    // MARK: Actions

    @IBAction func handleSearchBarButtonItemTap(_ sender: Any) {
        performSegue(withIdentifier: .showContactSearch, sender: nil)
    }
}

// MARK: - UITableViewDataSource

extension ContactsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueDefaultReusableCell()

        let contact = viewModel.contact(at: indexPath)
        cell.textLabel?.text = "\(indexPath.row): \(contact.name)"
        cell.detailTextLabel?.text = contact.address

        return cell
    }
}

// MARK: - UITableViewDelegate

extension ContactsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = viewModel.contact(at: indexPath)

    }
}
