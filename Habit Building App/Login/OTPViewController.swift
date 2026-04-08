//
//  OTPViewController.swift
//  habitSignIn
//
//  Created by GEU on 06/02/26.
//

import UIKit

class OTPViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var otp1TextField: UITextField!
    @IBOutlet weak var otp2TextField: UITextField!
    @IBOutlet weak var otp3TextField: UITextField!
    @IBOutlet weak var otp4TextField: UITextField!

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!

    var countdownTimer: Timer?
    var remainingSeconds: Int = 60

    // IMPORTANT (email from previous screen)
    var email: String = ""

    // FAKE OTP
    var generatedOTP: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupOTPFields()
        startTimer()
    }

    func setupOTPFields() {
        let textFields = [otp1TextField, otp2TextField, otp3TextField, otp4TextField]

        for tf in textFields {
            tf?.delegate = self
            tf?.keyboardType = .numberPad
            tf?.textAlignment = .center
        }

        textFields.forEach { $0?.text = "" }
        otp1TextField.becomeFirstResponder()
    }

    @IBAction func resetButtonTapped(_ sender: UIButton) {
        print("OTP Resent")
        startTimer()
    }

    // FIXED OTP CHECK
    private func verifyOTP() {

        let otpCode =
        (otp1TextField.text ?? "") +
        (otp2TextField.text ?? "") +
        (otp3TextField.text ?? "") +
        (otp4TextField.text ?? "")

        print("Entered OTP:", otpCode)

        if otpCode.count == 4 {

            if otpCode == generatedOTP {
                performSegue(withIdentifier: "showCreatePasswordScreen", sender: email)
            } else {
                showAlert(message: "Invalid OTP")
            }
        }
    }

    // CLEAR FIELDS ON WRONG OTP
    private func clearFields() {
        otp1TextField.text = ""
        otp2TextField.text = ""
        otp3TextField.text = ""
        otp4TextField.text = ""
        otp1TextField.becomeFirstResponder()
    }

    // PASS EMAIL TO NEXT SCREEN
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCreatePasswordScreen",
           let destination = segue.destination as? CreatePasswordViewController,
           let email = sender as? String {

            destination.email = email
        }
    }

    // MARK: - TextField Handling

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string.isEmpty {
            textField.text = ""
            moveToPreviousField(from: textField)
            return false
        }

        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }

        if let currentText = textField.text, currentText.count >= 1 {
            return false
        }

        textField.text = string
        moveToNextField(from: textField)
        verifyOTP()

        return false
    }

    private func moveToNextField(from textField: UITextField) {
        switch textField {
        case otp1TextField: otp2TextField.becomeFirstResponder()
        case otp2TextField: otp3TextField.becomeFirstResponder()
        case otp3TextField: otp4TextField.becomeFirstResponder()
        case otp4TextField: otp4TextField.resignFirstResponder()
        default: break
        }
    }

    private func moveToPreviousField(from textField: UITextField) {
        switch textField {
        case otp4TextField: otp3TextField.becomeFirstResponder()
        case otp3TextField: otp2TextField.becomeFirstResponder()
        case otp2TextField: otp1TextField.becomeFirstResponder()
        default: break
        }
    }

    // MARK: - Timer

    func startTimer() {
        remainingSeconds = 60
        resendButton.isEnabled = false
        resendButton.alpha = 0.5

        timerLabel.text = "You can resend the code in \(remainingSeconds) seconds"

        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                              target: self,
                                              selector: #selector(updateTimer),
                                              userInfo: nil,
                                              repeats: true)
    }

    @objc func updateTimer() {
        remainingSeconds -= 1
        timerLabel.text = "You can resend the code in \(remainingSeconds) seconds"

        if remainingSeconds <= 0 {
            countdownTimer?.invalidate()
            resendButton.isEnabled = true
            resendButton.alpha = 1.0
        }
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
