import UIKit

protocol CreateJournalViewControllerDelegate: AnyObject {
    func createJournal(vc: CreateJournalViewController, didCreate journal: Journal)
}

final class CreateJournalViewController: UIViewController {

    weak var delegate: CreateJournalViewControllerDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    var textField: UITextField = {
        let textField: UITextField = .init()

        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false

        return textField
    }()

    @objc
    func closeView() {
        navigationController?.popViewController(animated: true)

        dismiss(animated: true, completion: nil) // TODO: закрывать в JournalTableViewController
    }

    @objc func createJournal() {
        guard let text = textField.text else {
            closeView()
            return
        }

        delegate?.createJournal(vc: self, didCreate: .init(group: .init(groupName: text, students: nil)))
        closeView()
    }

    func setupViews() {
        view.backgroundColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(createJournal))
        navigationItem.title = "Create Journal"


        view.addSubview(textField)
//        TODO: "".trimmingCharacters - подписавшись на делегат
//        TODO: firstField.addTarget(self, action: <#T##Selector#>, for: .valueChanged) - в селектор будут отправляться изменения
        textField.placeholder = "Write the group number"
        textField.backgroundColor = .secondarySystemFill

        NSLayoutConstraint.activate([
            textField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 75),
            textField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            textField.heightAnchor.constraint(equalToConstant: 40)])
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
