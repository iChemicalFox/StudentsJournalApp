import UIKit

final class StudentsTableViewController: UITableViewController {
    private let shouldShowCloseButton: Bool
    private let navigationTitle: String
    private let cellId = "cellId"
    private let journalModel = JournalModel()

    init(shouldShowCloseButton: Bool, navigationTitle: String) {
        self.shouldShowCloseButton = shouldShowCloseButton
        self.navigationTitle = navigationTitle

        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = .white

        setupNavigationBar()

        tableView.register(StudentCell.self, forCellReuseIdentifier: cellId)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! StudentCell
        // в prepare for reuse отправлять пустую ячейку

        let cells = journalModel.getStudents(group: navigationTitle)

        if !cells.isEmpty {
            cell.studentName.text = "\(cells[indexPath.row].firstName) \(cells[indexPath.row].secondName)"
        }

        cell.studentsTableViewController = self

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cells = journalModel.getStudents(group: navigationTitle)

        return cells.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = SubjectsTableViewController(shouldShowCloseButton: false)
        navigationController?.pushViewController(destination, animated: true)
    }

    private func setupNavigationBar() {
        navigationItem.title = "Students: \(navigationTitle)"

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

    private func insertCell(with model: Student) {
        journalModel.addStudent(student: model, for: navigationTitle)
    }

    func deleteCell(cell: UITableViewCell) {
        if let deletionIndexPath = tableView.indexPath(for: cell) {
            journalModel.removeStudent(index: deletionIndexPath.row, by: navigationTitle)
            tableView.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
    }

    @objc private func addNewStudent() {
        let viewController = CreateStudentViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.delegate = self
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: StudentsTableViewController + CreateStudentViewControllerDelegate

extension StudentsTableViewController: CreateStudentViewControllerDelegate {
    func createStudent(vc: CreateStudentViewController, didCreate student: Student) {
        insertCell(with: student)
        
        tableView.reloadData()
    }
}
