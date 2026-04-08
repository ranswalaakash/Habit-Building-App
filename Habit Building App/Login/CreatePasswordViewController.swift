//
//  CreatePasswordViewController.swift
//  habitSignIn
//
//  Created by GEU on 09/02/26.
//

import UIKit

class CreatePasswordViewController: UIViewController {

    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet private weak var eyeButton: UIButton!
    @IBOutlet private weak var eyeButton2: UIButton!

    // for OTP screen
    var email: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Toggle Password
    @IBAction func togglePasswordVisibility(_ sender: UIButton) {
        newPasswordTextField.isSecureTextEntry.toggle()
        updateEyeIcon()
    }

    @IBAction func togglePasswordVisibility2(_ sender: UIButton) {
        confirmPasswordTextField.isSecureTextEntry.toggle()
        updateEyeIcon()
    }

    private func updateEyeIcon() {
        let imageName = newPasswordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        eyeButton.setImage(UIImage(systemName: imageName), for: .normal)

        let imageName2 = confirmPasswordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        eyeButton2.setImage(UIImage(systemName: imageName2), for: .normal)
    }

    // MARK: - Save Password
    @IBAction func savePasswordTapped(_ sender: UIButton) {

        let newPass = newPasswordTextField.text ?? ""
        let confirmPass = confirmPasswordTextField.text ?? ""

        // Validation
        if newPass.isEmpty || confirmPass.isEmpty {
            showAlert("Please fill all the fields")
            return
        }

        if newPass != confirmPass {
            showAlert("Passwords do not match")
            return
        }

        if newPass.count < 6 {
            showAlert("Password must be at least 6 characters long")
            return
        }
      // UPDATE PASSWORD IN DATABASE
        let success = DatabaseManager.shared.updatePassword(email: email, newPassword: newPass)

        if success {
            let alert = UIAlertController(title: "Success",
                                          message: "Password updated successfully",
                                          preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.navigateBackToLogin()
            })

            present(alert, animated: true)

        } else {
            showAlert("Failed to update password")
        }
    }

    // MARK: - Alert
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Navigation
    func navigateBackToLogin() {
        navigationController?.popToRootViewController(animated: true)
    }
}
