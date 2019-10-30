//
//  ContactSearchViewController.swift
//  MSSG
//
//  Created by Max Rozdobudko on 30.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class ContactSearchViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: DesignButton!

    // MARK: View model

    var viewModel: ContactSearchViewModel!

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // tableView

        tableView.registerDefaultReusableCell()
        tableView.dataSource = self
        tableView.delegate = self

        // reactive

        viewModel.query <~ searchBar.reactive.continuousTextValues

        searchButton.reactive.pressed = CocoaAction(viewModel.search)

        viewModel.results.signal
            .observe(on: UIScheduler())
            .take(duringLifetimeOf: self)
            .observeValues { [weak self] _ in
                self?.tableView.reloadData()
            }

        viewModel.search.errors
            .observe(on: UIScheduler())
            .take(duringLifetimeOf: self)
            .observeValues { [weak self] error in
                self?.showAlert(withError: error)
            }

        viewModel.add.errors
            .observe(on: UIScheduler())
            .take(duringLifetimeOf: self)
            .observeValues { [weak self] error in
                self?.showAlert(withError: error)
            }

        // Do any additional setup after loading the view.
    }

    fileprivate func add(contact: ContactModel) {
        viewModel.add.apply(contact)
            .observe(on: UIScheduler())
            .startWithCompleted { [weak self] in
                self?.showAlert(withTitle: "Congrats!", message: "Contact \(contact.name) successfully added to your contact list.")
            }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDataSource

extension ContactSearchViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueDefaultReusableCell()

        let contact = viewModel.contact(at: indexPath)
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.address

        return cell
    }
}

// MARK: - UITableViewDelegate

extension ContactSearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = viewModel.contact(at: indexPath)
        let alert = UIAlertController(title: "Add Contact", message: "Do you want to add \(contact.name) to your contact list?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes, add a contact", style: .default, handler: { [weak self] action in
            self?.add(contact: contact)
        }))
        alert.addAction(UIAlertAction(title: "No, thank you", style: .cancel, handler: nil))
        self.present(alert, animated: true) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
