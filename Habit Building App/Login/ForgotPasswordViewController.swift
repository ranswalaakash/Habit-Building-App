import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!

    // 🔥 Store OTP
    var generatedOTP: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - UI Setup
    private func configureUI() {
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
    }

    // MARK: - Send OTP Button
    @IBAction private func sendOTPButtonTapped(_ sender: UIButton) {

        let email = emailTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        // 1. Empty check
        guard !email.isEmpty else {
            showAlert(message: "Please enter your email")
            return
        }

        // 2. Format check
        guard isValidEmail(email) else {
            showAlert(message: "Please enter a valid email address")
            return
        }

        // 3. Database check
        let exists = DatabaseManager.shared.isEmailExists(email: email)

        if exists {

            //  GENERATE RANDOM OTP
            generatedOTP = String(format: "%04d", Int.random(in: 0...9999))
            print("Generated OTP:", generatedOTP)

            //  SHOW OTP IN ALERT
            let alert = UIAlertController(
                title: "OTP Sent",
                message: "Your OTP is \(generatedOTP)",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                self.performSegue(withIdentifier: "goToOTPScreen", sender: email)
            })

            present(alert, animated: true)

        } else {
            showAlert(message: "Email not found")
        }
    }

    // MARK: - Prepare for Segue (PASS DATA)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToOTPScreen",
           let destination = segue.destination as? OTPViewController,
           let email = sender as? String {

            destination.email = email
            destination.generatedOTP = generatedOTP   //  PASS OTP
        }
    }

    // MARK: - Email Validation
    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }

    // MARK: - Alert
    private func showAlert(title: String = "Error", message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
