//
//  CreateFeedbackViewController.swift
//  MSSG
//
//  Created by Max Rozdobudko on 06.11.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit

class CreateFeedbackViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet fileprivate weak var descriptionTextField: UITextField!

    @IBOutlet fileprivate var submitButton: UIButton!

    // MARK: View model

    var viewModel: CreateFeedbackViewModel!

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
