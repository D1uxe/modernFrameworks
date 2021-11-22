//
//  AuthViewController.swift
//  ModernFrameworks
//
//  Created by MacBook Pro on 15.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

class AuthViewController: UIViewController, Routable {

	@IBOutlet var loginTextField: UITextField!
	@IBOutlet var passwordTextField: UITextField!
	@IBOutlet var loginButton: UIButton!
	@IBOutlet var registerButton: UIButton!
	@IBOutlet var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

		configureLoginBindings()
    }

	// MARK: - Private Methods

	@IBAction private func loginButtonPressed() {

		guard let login = loginTextField.text,
			  let password = passwordTextField.text
		else { return }

		if let _ = BaseRealm.read(of: User.self).first(where: {$0.login == login && $0.password == password}) {
			UserDefaults.standard.set(true, forKey: "isLogin")
			// делаем переход map controller
			navigationController?.setViewControllers([MapViewController.instantiate(fromStoryboard: "Main")], animated: true)
		} else {
			errorLabel.text = "Такого пользователя нет"
		}
	}

	@IBAction private func registerButtonPressed() {
		present(RegistrViewController.instantiate(fromStoryboard: "Registration"), animated: true, completion: nil)

	}

	private func configureLoginBindings() {
			Observable
				.combineLatest(
					loginTextField.rx.text,
					passwordTextField.rx.text
				)
				.map { login, password in
					return !(login ?? "").isEmpty && (password ?? "").count >= 6
				}
				.bind { [weak loginButton, weak registerButton ] inputFilled in
					loginButton?.isEnabled = inputFilled
			}
		}

}
