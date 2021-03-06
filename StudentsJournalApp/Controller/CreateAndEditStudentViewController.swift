import UIKit

protocol CreateAndEditStudentViewControllerDelegate: AnyObject {
    func createStudent(vc: CreateAndEditStudentViewController, didCreate student: Student)
    func editStudent(vc: CreateAndEditStudentViewController, didUpdate student: Student)
}

final class CreateAndEditStudentViewController: UIViewController {
    let state: State
    let student: Student?

    weak var delegate: CreateAndEditStudentViewControllerDelegate?

    init(student: Student? = nil) {
        self.student = student

        if student == nil {
            self.state = .create
        } else {
            self.state = .edit
        }

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameTextField.delegate = self
        secondNameTextField.delegate = self

        setupViews()
    }

    var firstNameTextField: UITextField = {
        let textField = UITextField()

        textField.backgroundColor = .white
        textField.layer.cornerRadius = 6

        return textField
    }()

    var secondNameTextField: UITextField = {
        let textField = UITextField()

        textField.backgroundColor = .white
        textField.layer.cornerRadius = 6

        return textField
    }()

    @objc private func createStudent() {
        guard let firstName = firstNameTextField.text, let secondName = secondNameTextField.text else {
            return
        }

        delegate?.createStudent(vc: self, didCreate: Student(id: UUID().uuidString, firstName: firstName, secondName: secondName, subjects: []))
    }

    @objc private func editStudent() {
        guard let firstNameText = firstNameTextField.text else {
            return
        }

        guard let secondNameText = secondNameTextField.text else {
            return
        }

        guard var student = student else { return }

        student.firstName = firstNameText
        student.secondName = secondNameText

        delegate?.editStudent(vc: self, didUpdate: student)
    }

    private func setupViews() {
        view.backgroundColor = .white

        switch state {
        case .edit:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                target: self,
                                                                action: #selector(editStudent))
            navigationItem.title = NSLocalizedString("Edit student", comment: "")

            firstNameTextField.text = student?.firstName
            secondNameTextField.text = student?.secondName

        case .create:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                target: self,
                                                                action: #selector(createStudent))
            navigationItem.title = NSLocalizedString("Create student", comment: "")
        }

        view.addSubview(firstNameTextField)
        firstNameTextField.placeholder = NSLocalizedString("Write the first name", comment: "")
        firstNameTextField.backgroundColor = .secondarySystemFill
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            firstNameTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            firstNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            firstNameTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])

        view.addSubview(secondNameTextField)
        secondNameTextField.placeholder = NSLocalizedString("Write the second name", comment: "")
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

extension CreateAndEditStudentViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(
                in: textRange,
                with: string
            )

            if updatedText.count > 12 {
                return false
            }

            textField.text = text.trimmingCharacters(in: .decimalDigits)
        }

        return true
    }
}

// MARK: CreateAndEditStudentViewController + State

extension CreateAndEditStudentViewController {
    enum State {
        case edit
        case create
    }
}
