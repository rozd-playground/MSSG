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

    @IBOutlet fileprivate weak var descriptionTextField: UITextField!

    @IBOutlet fileprivate var submitButton: UIButton!

    // MARK: View model

    var viewModel: CreateFeedbackViewModel!

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // reactive

        viewModel.rating <~ ratingSlider.reactive.values

        viewModel.detail <~ descriptionTextField.reactive.continuousTextValues

        submitButton.reactive.pressed = CocoaAction(viewModel.rate)
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
