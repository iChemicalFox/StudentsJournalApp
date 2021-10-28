import UIKit

final class JournalTableViewController: UITableViewController {
    private let shouldShowCloseButton: Bool
    private let journalModel = JournalModel()
    private let cellId = "cellId"

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

        tableView.register(JournalCell.self, forCellReuseIdentifier: cellId)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! JournalCell
        // в prepare for reuse отправлять пустую ячейку

        let groups = journalModel.getJournals()

        if !groups.isEmpty {
            cell.label.text = groups[indexPath.row].group.groupName
        }

        cell.journalTableViewController = self

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cells = journalModel.getJournals()

        return cells.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groups = journalModel.getJournals()
        
        let groupName = groups[indexPath.row].group.groupName // не исключен фатал

        let destination = StudentsTableViewController(shouldShowCloseButton: false, navigationTitle: groupName)
        navigationController?.pushViewController(destination, animated: true)
    }

    private func setupNavigationBar() {
        navigationItem.title = "Journal"

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

    private func insertCell(with model: Journal) {
        journalModel.addJournal(journal: model)
    }

    func deleteCell(cell: UITableViewCell) {
        if let deletionIndexPath = tableView.indexPath(for: cell) {
            journalModel.removeJournal(index: deletionIndexPath.row)
            tableView.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
    }

    @objc private func addNewJournal() {
        let viewController = CreateJournalViewController()
        let navigationController = UINavigationController(rootViewController: viewController)

        viewController.delegate = self

        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: JournalTableViewController + CreateJournalViewControllerDelegate

extension JournalTableViewController: CreateJournalViewControllerDelegate {
    func createJournal(vc: CreateJournalViewController, didCreate journal: Journal) {
        insertCell(with: journal)

        tableView.reloadData()
    }
}
