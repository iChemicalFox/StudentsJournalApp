import UIKit

protocol CreateAndEditJournalViewControllerDelegate: AnyObject {
    func createJournal(vc: CreateAndEditJournalViewController, didCreate journal: Journal)
    func editJournalName(vc: CreateAndEditJournalViewController, didUpdate journal: Journal)
}

final class CreateAndEditJournalViewController: UIViewController {
    let state: State
    let journal: Journal?

    weak var delegate: CreateAndEditJournalViewControllerDelegate?

    init(journal: Journal? = nil) {
        self.journal = journal

        if journal == nil {
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

        textField.delegate = self

        setupViews()
    }

    var textField: UITextField = {
        let textField = UITextField()

        textField.backgroundColor = .white
        textField.layer.cornerRadius = 6

        return textField
    }()

    @objc private func createJournal() {
        guard let text = textField.text else {
            return
        }

        delegate?.createJournal(vc: self, didCreate: Journal(id: UUID().uuidString, groupName: text, students: []))
    }

    @objc private func editJournalName() {
        guard let text = textField.text, var journal = journal else { return }

        journal.groupName = text

        delegate?.editJournalName(vc: self, didUpdate: journal)
    }

    private func setupViews() {
        view.backgroundColor = .white

        switch state {
        case .create:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                target: self,
                                                                action: #selector(createJournal))
            navigationItem.title = NSLocalizedString("Create journal", comment: "")

        case .edit:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                target: self,
                                                                action: #selector(editJournalName))
            navigationItem.title = NSLocalizedString("Edit group", comment: "")

            textField.text = journal?.groupName
        }

        view.addSubview(textField)
        textField.placeholder = NSLocalizedString("Write the group number", comment: "")
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

extension CreateAndEditJournalViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(
                in: textRange,
                with: string
            )

            if updatedText.count > 5 {
                return false
            }
        }

        return true
    }
}

// MARK: CreateJournalViewController + State

extension CreateAndEditJournalViewController {
    enum State {
        case edit
        case create
    }
}
