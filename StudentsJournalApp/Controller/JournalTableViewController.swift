import UIKit

final class JournalTableViewController: UITableViewController {
    private let shouldShowCloseButton: Bool
    private let journalModel = JournalModel()
    private let groupLimit = 10
    private let cellHeight: CGFloat = 40

    init(shouldShowCloseButton: Bool) {
        self.shouldShowCloseButton = shouldShowCloseButton

        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = .white

        setupNavigationBar()

        tableView.register(JournalCell.self, forCellReuseIdentifier: "\(JournalCell.self)")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(JournalCell.self)", for: indexPath) as! JournalCell
        // в prepare for reuse отправлять пустую ячейку

        let groups = journalModel.journals

        if !groups.isEmpty {
            cell.textLabel?.text = groups[indexPath.row].groupName
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cells = journalModel.journals

        if cells.count > groupLimit {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }

        return cells.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeight
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groups = journalModel.journals
        
        let groupId = groups[indexPath.row].id // не исключен фатал

        let destination = StudentsTableViewController(shouldShowCloseButton: false, journalId: groupId)
        navigationController?.pushViewController(destination, animated: true)
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: NSLocalizedString("Delete", comment: "")) { [weak journalModel] (action, view, handler) in
            guard let model = journalModel else { return }

            tableView.beginUpdates()

            model.removeJournal(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)

            tableView.endUpdates()
        }

        let editAction = UIContextualAction(style: .normal,
                                            title: NSLocalizedString("Edit", comment: "")) { [weak self, journalModel] (action, view, handler) in

            let journal = journalModel.journals[indexPath.row]
            self?.editJournal(journal: journal)
        }

        editAction.backgroundColor = .gray
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false

        return configuration
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    private func setupNavigationBar() {
        navigationItem.title = NSLocalizedString("Journals", comment: "")

        if shouldShowCloseButton {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "close",
                image: nil,
                primaryAction: UIAction(handler: { [weak self] _ in
                    self?.dismiss(animated: true, completion: nil)
                }), menu: nil
            )
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                target: self,
                                                                action: #selector(addNewJournal))
        }
    }

    @objc private func addNewJournal() {
        let viewController = CreateAndEditJournalViewController()
        let navigationController = UINavigationController(rootViewController: viewController)

        viewController.delegate = self

        present(navigationController, animated: true, completion: nil)
    }

    private func editJournal(journal: Journal) {
        let viewController = CreateAndEditJournalViewController(journal: journal)
        let navigationController = UINavigationController(rootViewController: viewController)

        viewController.delegate = self

        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: JournalTableViewController + CreateJournalViewControllerDelegate

extension JournalTableViewController: CreateAndEditJournalViewControllerDelegate {
    func createJournalDidClose(vc: CreateAndEditJournalViewController, didCreate journal: Journal) {
        journalModel.add(journal: journal)

        tableView.reloadData()
        vc.dismiss(animated: true, completion: nil)
    }

    func editJournalNameDidClose(vc: CreateAndEditJournalViewController, journal: Journal, newName: String) {
        journalModel.editGroupName(journal: journal, newValue: newName)

        tableView.reloadData()
        vc.dismiss(animated: true, completion: nil)
    }
}
