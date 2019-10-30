//
//  AuthViewController.swift
//  MSSG
//
//  Created by Max Rozdobudko on 29.10.2019.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class AuthViewController: UIViewController {

    @IBOutlet weak var mnemonicTextField: UITextView!

    @IBOutlet weak var signInButton: UIButton!

    @IBOutlet weak var signUpButton: UIButton!

    // MARK: View model

    var viewModel: AuthViewModel!

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // reactive

        mnemonicTextField.reactive.text <~ viewModel.recoveryPhrase

        viewModel.recoveryPhrase <~ mnemonicTextField.reactive.continuousTextValues

        viewModel.signUp.values
            .take(duringLifetimeOf: self)
            .observe(on: UIScheduler())
            .observeValues { [weak self] phrase in
                self?.showAlert(withTitle: "Your Recovery Phrase Is", message: phrase)
            }

        signUpButton.reactive.pressed = CocoaAction(viewModel.signUp)

        signInButton.reactive.pressed = CocoaAction(viewModel.signIn)
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
