
import UIKit

final class AddAccountTableViewController: UITableViewController {


// MARK: - IndexPaths
private let dobLabelIndexPath = IndexPath(row: 3, section: 0)
private let dobPickerIndexPath = IndexPath(row: 4, section: 0)

private let childDOBLabelIndexPath = IndexPath(row: 2, section: 2)
private let childDOBPickerIndexPath = IndexPath(row: 3, section: 2)

// MARK: - Outlets
@IBOutlet weak var DOBDateLabel: UILabel!
@IBOutlet weak var DOBDatePicker: UIDatePicker!

@IBOutlet weak var childDOBLabel: UILabel!
@IBOutlet weak var childDOBDatePicker: UIDatePicker!

@IBOutlet private weak var firstNameTextField: UITextField!
@IBOutlet private weak var lastNameTextField: UITextField!
@IBOutlet private weak var emailTextField: UITextField!

@IBOutlet private weak var genderTextField: UITextField!
@IBOutlet weak var childGenderTextField: UITextField!

@IBOutlet weak var stepperLabel: UILabel!
@IBOutlet weak var childStepper: UIStepper!

@IBOutlet weak var childNameTextField: UITextField!
@IBOutlet weak var chidAgeTextField: UITextField!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureDatePicker()
        setupKeyboardDismiss()
        setupGestures()

        DOBDateLabel.text = "Select your DOB"
        childDOBLabel.text = "Select Child DOB"

        // Hide pickers initially
        DOBDatePicker.isHidden = true
        childDOBDatePicker.isHidden = true
    }


    @IBAction func saveButtonTapped(_ sender: UIButton) {

        // Validate First Name
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            showAlert(message: "Please enter your first name")
            return
        }

        // Validate Last Name
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            showAlert(message: "Please enter your last name")
            return
        }

        // Validate Email
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(message: "Please enter your email")
            return
        }

        // Validate Gender
        guard let gender = genderTextField.text, !gender.isEmpty else {
            showAlert(message: "Please select gender")
            return
        }

        // Validate DOB
        guard DOBDateLabel.text != "Date of Birth" else {
            showAlert(message: "Please select your date of birth")
            return
        }

        // TEMP PASSWORD (since no password field here)
        let password = "123456"

        //  INSERT INTO DATABASE
        let success = DatabaseManager.shared.insertUser(email: email, password: password)

        print("Insert result:", success)

        if success {
            let alert = UIAlertController(
                title: "Success",
                message: "Account created successfully",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                //  GO BACK TO LOGIN
                self.navigationController?.popViewController(animated: true)
            })

            present(alert, animated: true)

        } else {
            showAlert(message: "User already exists or error occurred")
        }
    }
    
    func showAlert(message: String) {
        
        let alert = UIAlertController(
            title: "Incomplete Details",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    // MARK: - Variables
var numberOfChildren = 0
var isDOBDatePickerVisible = false
var isChildDOBPickerVisible = false


// MARK: - UI Setup
private func configureUI() {
    emailTextField.keyboardType = .emailAddress
    emailTextField.autocapitalizationType = .none
    stepperLabel.text = "0"
}

private func configureDatePicker() {
    DOBDatePicker.datePickerMode = .date
    DOBDatePicker.maximumDate = Date()

    childDOBDatePicker.datePickerMode = .date
    childDOBDatePicker.maximumDate = Date()
}

private func setupKeyboardDismiss() {
    let tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tapGesture)
}

private func setupGestures() {

    // Parent DOB
    let dobTap = UITapGestureRecognizer(target: self,
                                        action: #selector(dobTapped))
    DOBDateLabel.isUserInteractionEnabled = true
    DOBDateLabel.addGestureRecognizer(dobTap)

    // Child DOB
    let childDobTap = UITapGestureRecognizer(target: self,
                                             action: #selector(childDobTapped))
    childDOBLabel.isUserInteractionEnabled = true
    childDOBLabel.addGestureRecognizer(childDobTap)

    // Parent Gender
    let genderTap = UITapGestureRecognizer(target: self,
                                           action: #selector(genderTapped))
    genderTextField.isUserInteractionEnabled = true
    genderTextField.addGestureRecognizer(genderTap)

    // Child Gender
    let childGenderTap = UITapGestureRecognizer(target: self,
                                                action: #selector(childGenderTapped))
    childGenderTextField.isUserInteractionEnabled = true
    childGenderTextField.addGestureRecognizer(childGenderTap)
}

@objc private func dismissKeyboard() {
    view.endEditing(true)
}

// MARK: - Parent DOB
@IBAction func datePickerChanged(_ sender: UIDatePicker) {
    updateDateViews()
}

private func updateDateViews() {
    DOBDateLabel.text = DOBDatePicker.date.formatted(
        date: .abbreviated,
        time: .omitted
    )
}

@objc private func dobTapped() {

    isDOBDatePickerVisible.toggle()
    DOBDatePicker.isHidden = !isDOBDatePickerVisible

    tableView.beginUpdates()
    tableView.endUpdates()
}

// MARK: - Child DOB
@IBAction func childDOBChanged(_ sender: UIDatePicker) {

    childDOBLabel.text = sender.date.formatted(
        date: .abbreviated,
        time: .omitted
    )
}

@objc private func childDobTapped() {

    isChildDOBPickerVisible.toggle()
    childDOBDatePicker.isHidden = !isChildDOBPickerVisible

    tableView.beginUpdates()
    tableView.endUpdates()
}

// MARK: - Parent Gender
@objc private func genderTapped() {

    let alert = UIAlertController(title: "Select Gender",
                                  message: nil,
                                  preferredStyle: .actionSheet)

    ["Male","Female","Other"].forEach { gender in
        alert.addAction(UIAlertAction(title: gender,
                                      style: .default) { _ in
            self.genderTextField.text = gender
        })
    }

    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

    present(alert, animated: true)
}

// MARK: - Child Gender
@objc private func childGenderTapped() {

    let alert = UIAlertController(title: "Select Child Gender",
                                  message: nil,
                                  preferredStyle: .actionSheet)

    ["Male","Female","Other"].forEach { gender in
        alert.addAction(UIAlertAction(title: gender,
                                      style: .default) { _ in
            self.childGenderTextField.text = gender
        })
    }

    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

    present(alert, animated: true)
}

// MARK: - Stepper
@IBAction func stepperValueChanged(_ sender: UIStepper) {

    numberOfChildren = Int(sender.value)
    stepperLabel.text = "\(numberOfChildren)"

    tableView.beginUpdates()
    tableView.endUpdates()
}

// MARK: - Row Height Logic
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath == dobPickerIndexPath {
            return isDOBDatePickerVisible ? 300 : 0
        }

        if indexPath == childDOBPickerIndexPath {
            return isChildDOBPickerVisible ? 300 : 0
        }

        if indexPath.section == 2 && numberOfChildren == 0 {
            return 0
        }

        return UITableView.automaticDimension
    }

override func tableView(_ tableView: UITableView,
                        estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

    if indexPath == dobPickerIndexPath || indexPath == childDOBPickerIndexPath {
        return 300
    }

    return UITableView.automaticDimension
}


}
