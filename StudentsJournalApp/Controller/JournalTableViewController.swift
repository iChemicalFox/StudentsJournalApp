import UIKit

// MARK: JournalTableViewController

final class JournalTableViewController: UITableViewController {
    let isPresented: Bool
    let cellId = "cellId"
    var items = [Journal]()

    init(isPresented: Bool) {
        self.isPresented = isPresented

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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? JournalCell else {
            return UITableViewCell()
        }

        cell.label.text = items[indexPath.row].group.groupName
        cell.journalTableViewController = self

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = StudentsTableViewController(isPresented: false)
        navigationController?.pushViewController(destination, animated: true)
    }

    private func setupNavigationBar() {
        navigationItem.title = "Journal"

        if isPresented {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "close",
                image: nil,
                primaryAction: UIAction(handler: { [weak self] _ in
                    self?.dismiss(animated: true, completion: nil)
                }), menu: nil)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewJournal))
        }
    }

    func insertCell(with model: Journal) {
        items.append(model)
    }

    func deleteCell(cell: UITableViewCell) {
        if let deletionIndexPath = tableView.indexPath(for: cell) {
            items.remove(at: deletionIndexPath.row)
            tableView.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
    }

    @objc
    func addNewJournal() {
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
