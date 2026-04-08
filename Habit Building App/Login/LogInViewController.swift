import UIKit

final class LogInViewController: UIViewController {

 
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var eyeButton: UIButton!
    @IBOutlet private weak var forgotPasswordButton: UIButton!
    @IBOutlet private weak var createNewAccountButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    
    private func configureUI() {
        passwordTextField.isSecureTextEntry = true
        updateEyeIcon()
    }

    
    @IBAction private func togglePasswordVisibility(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        updateEyeIcon()
    }

    @IBAction func loginTapped(_ sender: UIButton) {

        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        if email.isEmpty || password.isEmpty {
            showAlert(message: "Please fill all fields")
            return
        }

        let isValid = DatabaseManager.shared.validateUser(email: email, password: password)

        if isValid {
            print("Login Success")
        } else {
            showAlert(message: "Invalid email or password") 
        }
    }

    @IBAction private func forgotPasswordTapped(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(
            withIdentifier: "ForgotPasswordViewController"
        ) as? ForgotPasswordViewController else { return }

        
    }
    private func updateEyeIcon() {
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    private func showAlert(title: String = "Error", message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
