import UIKit

protocol CreateJournalViewControllerDelegate: AnyObject {
    func createJournal(vc: CreateJournalViewController, didCreate journal: Journal)
}

final class CreateJournalViewController: UIViewController {
    weak var delegate: CreateJournalViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        textField.delegate = self

        setupViews()
    }

    var textField: UITextField = {
        let textField = UITextField()

        textField.backgroundColor = .white

        return textField
    }()

    @objc private func closeView() {
        navigationController?.popViewController(animated: true)

        dismiss(animated: true, completion: nil) // TODO: закрывать в JournalTableViewController
    }

    @objc private func createJournal() {
        guard let text = textField.text else {
            closeView()
            return
        }

        delegate?.createJournal(vc: self, didCreate: Journal(id: UUID().uuidString, groupName: text, students: []))
        closeView()
    }

    private func setupViews() {
        view.backgroundColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(createJournal))
        navigationItem.title = NSLocalizedString("Create journal", comment: "")


        view.addSubview(textField)
        textField.placeholder = "Write the group number"
        textField.backgroundColor = .secondarySystemFill
        textField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            textField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            textField.heightAnchor.constraint(equalToConstant: 40)])
    }
}

// MARK: CreateJournalViewController + UITextFieldDelegate

extension CreateJournalViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)

            if updatedText.count > 5 {
                return false
            }
        }

        return true
    }
}
