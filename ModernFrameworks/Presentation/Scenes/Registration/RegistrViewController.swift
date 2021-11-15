//
//  RegistrViewController.swift
//  ModernFrameworks
//
//  Created by MacBook Pro on 15.11.2021.
//

import UIKit

class RegistrViewController: UIViewController, Routable {

	@IBOutlet var loginTextField: UITextField!
	@IBOutlet var passwordTextField: UITextField!
	@IBOutlet var signUpButton: UIButton!
	@IBOutlet var errorLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()

	}

	// MARK: - Private Methods

	@IBAction private func signUpButtonPressed() {

		guard let login = loginTextField.text,
			  let password = passwordTextField.text
		else { return }

		if BaseRealm.read(of: User.self).contains(where: {$0.login == login}) {
			errorLabel.text = "Логин занят, выберите другой"
		} else {
			let user = User(login: login, password: password)
			BaseRealm.write(objects: [user])
			// делаем переход на логин
			dismiss(animated: true, completion: nil)
			//present(AuthViewController.instantiate(fromStoryboard: "Auth"), animated: true, completion: nil)
		}
	}


}
