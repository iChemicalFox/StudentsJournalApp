import UIKit

final class SubjectsTableViewController: UITableViewController {
    private let shouldShowCloseButton: Bool
    private let cellId = "cellId"
    private var items: [Subject] = []

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

        tableView.register(SubjectCell.self, forCellReuseIdentifier: cellId)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SubjectCell

        cell.subjectName.text = "\(items[indexPath.row].name) rating: \(items[indexPath.row].grade)"
        cell.subjectsTableViewController = self

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }

    private func setupNavigationBar() {
        navigationItem.title = "Subjects"

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
                                                                action: #selector(addNewStudent))
        }
    }

    private func insertCell(with model: Subject) {
        items.append(model)
    }

    func deleteCell(cell: UITableViewCell) {
        if let deletionIndexPath = tableView.indexPath(for: cell) {
            items.remove(at: deletionIndexPath.row)
            tableView.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
    }

    @objc private func addNewStudent() {
        let viewController = CreateSubjectViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.delegate = self
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: SubjectsTableViewController + CreateSubjectViewControllerDelegate

extension SubjectsTableViewController: CreateSubjectViewControllerDelegate {
    func createSubject(vc: CreateSubjectViewController, didCreate subject: Subject) {
        insertCell(with: subject)
        
        tableView.reloadData()
    }
}
