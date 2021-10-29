import UIKit

protocol CreateStudentViewControllerDelegate: AnyObject {
    func createStudent(vc: CreateStudentViewController, didCreate student: Student)
}

final class CreateStudentViewController: UIViewController {
    weak var delegate: CreateStudentViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameTextField.delegate = self
        secondNameTextField.delegate = self

        setupViews()
    }

    var firstNameTextField: UITextField = {
        let textField = UITextField()

        textField.backgroundColor = .white

        return textField
    }()

    var secondNameTextField: UITextField = {
        let textField = UITextField()

        textField.backgroundColor = .white

        return textField
    }()

    @objc private func closeView() {
        navigationController?.popViewController(animated: true)

        dismiss(animated: true, completion: nil) // TODO: закрывать в StudentsTableViewController
    }

    @objc private func createStudent() {
        guard let firstName = firstNameTextField.text, let secondName = secondNameTextField.text else {
            closeView()
            return
        }

        delegate?.createStudent(vc: self, didCreate: Student(firstName: firstName, secondName: secondName, subjects: nil))
        closeView()
    }

    private func setupViews() {
        view.backgroundColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(createStudent))
        navigationItem.title = "Create student"


        view.addSubview(firstNameTextField)
//        TODO: "".trimmingCharacters - подписавшись на делегат
//        TODO: firstField.addTarget(self, action: <#T##Selector#>, for: .valueChanged) - в селектор будут отправляться изменения
        firstNameTextField.placeholder = "Write the first name"
        firstNameTextField.backgroundColor = .secondarySystemFill
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            firstNameTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            firstNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            firstNameTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])

        view.addSubview(secondNameTextField)
        secondNameTextField.placeholder = "Write the second name"
        secondNameTextField.backgroundColor = .secondarySystemFill
        secondNameTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            secondNameTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            secondNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 20),
            secondNameTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            secondNameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

// MARK: CreateStudentViewController + UITextFieldDelegate

extension CreateStudentViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)

            if updatedText.count > 12 {
                return false
            }

            textField.text = text.trimmingCharacters(in: .decimalDigits)
        }

        return true
    }
}
