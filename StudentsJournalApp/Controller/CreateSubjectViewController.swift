import UIKit

protocol CreateSubjectViewControllerDelegate: AnyObject {
    func createSubject(vc: CreateSubjectViewController, didCreate student: Subject)
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

    @objc private func closeView() {
        navigationController?.popViewController(animated: true)

        dismiss(animated: true, completion: nil) // TODO: закрывать в SubjectsTableViewController
    }

    @objc private func createSubject() {
        guard let subjectName = subjectNameTextField.text, let subjectRating = subjectRatingTextField.text else {
            closeView()
            return
        }

        let subjectRatingInt = Int(subjectRating)

        delegate?.createSubject(vc: self, didCreate: Subject(name: subjectName, grade: subjectRatingInt ?? 0))
        closeView()
    }

    private func setupViews() {
        view.backgroundColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(createSubject))
        navigationItem.title = "Create Subject"


        view.addSubview(subjectNameTextField)
//        TODO: "".trimmingCharacters - подписавшись на делегат
//        TODO: subjectRatingTextField.addTarget(self, action: <#T##Selector#>, for: .valueChanged) - в селектор будут отправляться изменения
        subjectNameTextField.placeholder = "Write the subject's name"
        subjectNameTextField.backgroundColor = .secondarySystemFill
        subjectNameTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            subjectNameTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            subjectNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            subjectNameTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            subjectNameTextField.heightAnchor.constraint(equalToConstant: 40)
        ])

        view.addSubview(subjectRatingTextField)
        subjectRatingTextField.placeholder = "Write the subject's rating"
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

// MARK: UITextFieldDelegate

extension CreateSubjectViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            
            if updatedText.count > 12 {
                return false
            }
            
            // можно провалидировать текст rating, что там только цифры
        }

        return true
    }
}
