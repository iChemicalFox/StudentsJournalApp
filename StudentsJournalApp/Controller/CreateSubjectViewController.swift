import UIKit

protocol CreateSubjectViewControllerDelegate: AnyObject {
    func createSubjectDidClose(vc: CreateSubjectViewController, didCreate student: Subject)
}

final class CreateSubjectViewController: UIViewController {
    weak var delegate: CreateSubjectViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        subjectNameTextField.delegate = self
        subjectRatingTextField.delegate = self

        setupViews()
    }

    var subjectNameTextField: UITextField = {
        let textField = UITextField()

        textField.backgroundColor = .white

        return textField
    }()

    var subjectRatingTextField: UITextField = {
        let textField = UITextField()

        textField.backgroundColor = .white

        return textField
    }()

    @objc private func createSubject() {
        guard let subjectName = subjectNameTextField.text, let subjectRating = subjectRatingTextField.text else {
            return
        }

        let subjectRatingInt = Int(subjectRating)

        delegate?.createSubjectDidClose(vc: self, didCreate: Subject(id: UUID().uuidString, name: subjectName, grade: subjectRatingInt ?? 0))
    }

    private func setupViews() {
        view.backgroundColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(createSubject))
        navigationItem.title = NSLocalizedString("Create subject", comment: "")


        view.addSubview(subjectNameTextField)
        subjectNameTextField.placeholder = NSLocalizedString("Write the subject's name", comment: "")
        subjectNameTextField.backgroundColor = .secondarySystemFill
        subjectNameTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            subjectNameTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            subjectNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            subjectNameTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            subjectNameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])

        view.addSubview(subjectRatingTextField)
        subjectRatingTextField.keyboardType = .asciiCapableNumberPad
        subjectRatingTextField.placeholder = NSLocalizedString("Write the subject's rating", comment: "")
        subjectRatingTextField.backgroundColor = .secondarySystemFill
        subjectRatingTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            subjectRatingTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            subjectRatingTextField.topAnchor.constraint(equalTo: subjectNameTextField.bottomAnchor, constant: 20),
            subjectRatingTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            subjectRatingTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

// MARK: CreateSubjectViewController + UITextFieldDelegate

extension CreateSubjectViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            
            if textField == subjectNameTextField {
                if updatedText.count > 16 {
                    return false
                }

                textField.text = text.trimmingCharacters(in: .decimalDigits)
            }

            if textField == subjectRatingTextField {
                if updatedText.count > 1 {
                    return false
                }
            }
        }

        return true
    }
}
