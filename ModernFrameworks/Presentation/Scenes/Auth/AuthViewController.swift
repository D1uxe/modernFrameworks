//
//  AuthViewController.swift
//  ModernFrameworks
//
//  Created by MacBook Pro on 15.11.2021.
//

import UIKit

class AuthViewController: UIViewController, Routable {

	@IBOutlet var loginTextField: UITextField!
	@IBOutlet var passwordTextField: UITextField!
	@IBOutlet var loginButton: UIButton!
	@IBOutlet var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

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

}
