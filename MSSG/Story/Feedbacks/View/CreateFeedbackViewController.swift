//
//  CreateFeedbackViewController.swift
//  MSSG
//
//  Created by Max Rozdobudko on 06.11.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class CreateFeedbackViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var ratingSlider: UISlider!

    @IBOutlet fileprivate weak var detailTextField: UITextField!

    @IBOutlet fileprivate var submitButton: UIButton!

    // MARK: View model

    var viewModel: CreateFeedbackViewModel!

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // reactive

        viewModel.rating <~ ratingSlider.reactive.values

        viewModel.detail <~ detailTextField.reactive.continuousTextValues

        submitButton.reactive.pressed = CocoaAction(viewModel.rate)

        viewModel.rate.errors
            .observe(on: UIScheduler())
            .take(duringLifetimeOf: self)
            .observeValues { [weak self] error in
                self?.showAlert(withError: error, handler: nil)
            }

        viewModel.rate.completed
            .observe(on: UIScheduler())
            .take(duringLifetimeOf: self)
            .observeValues { [weak self] in
                self?.showAlert(withTitle: "Posted!", message: "Thank you for your feedback.", handler: { _ in
                    // TODO: replace with a delegate
                    self?.navigationController?.popViewController(animated: true)
                })
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
