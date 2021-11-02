import UIKit

final class SubjectsTableViewController: UITableViewController {
    private let shouldShowCloseButton: Bool
    private let studentId: String
    private let journalId: String
    private let journalModel = JournalModel()

    init(shouldShowCloseButton: Bool, journalId: String, studentId: String) {
        self.shouldShowCloseButton = shouldShowCloseButton
        self.journalId = journalId
        self.studentId = studentId

        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = .white

        setupNavigationBar()

        tableView.register(SubjectCell.self, forCellReuseIdentifier: "\(SubjectCell.self)")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(SubjectCell.self)", for: indexPath) as! SubjectCell
        // в prepare for reuse отправлять пустую ячейку

        let subjects = journalModel.getSubjects(studentId: studentId, journalId: journalId)

        if !subjects.isEmpty {
            cell.subjectName.text = subjects[indexPath.row].name
            cell.subjectRating.text = subjects[indexPath.row].grade.description
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cells = journalModel.getSubjects(studentId: studentId, journalId: journalId)

        return cells.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
        }

        journalModel.removeSubject(index: indexPath.row, studentId: studentId, journalId: journalId)
        tableView.deleteRows(at: [indexPath], with: .automatic)

        tableView.endUpdates()
    }

    private func setupNavigationBar() {
        navigationItem.title = journalModel.getStudentName(journalId: journalId, studentId: studentId)

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
        journalModel.add(subject: model, for: studentId, in: journalId)
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
