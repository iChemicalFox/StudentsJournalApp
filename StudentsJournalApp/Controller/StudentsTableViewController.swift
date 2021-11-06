import UIKit

final class StudentsTableViewController: UITableViewController {
    private let shouldShowCloseButton: Bool
    private let journalId: String
    private let journalModel = JournalModel()

    init(shouldShowCloseButton: Bool, journalId: String) {
        self.shouldShowCloseButton = shouldShowCloseButton
        self.journalId = journalId

        super.init(style: .plain)

        navigationItem.title = journalModel.getGroupName(by: journalId)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = .white

        setupNavigationBar()

        tableView.register(StudentCell.self, forCellReuseIdentifier: "\(StudentCell.self)")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(StudentCell.self)", for: indexPath) as! StudentCell
        // в prepare for reuse отправлять пустую ячейку

        let students = journalModel.getStudents(journalId: journalId)
        let studentId = students[indexPath.row].id

        let averageRate = journalModel.getAverageRate(studentId: studentId, journalId: journalId)

        if !students.isEmpty {
            cell.studentName.text = "\(students[indexPath.row].firstName) \(students[indexPath.row].secondName)"
            cell.averageRate.text = String(format: "%.2f", averageRate)

            if averageRate >= 4 {
                cell.averageRate.textColor = .green
            }

            if averageRate < 4 && averageRate >= 3 {
                cell.averageRate.textColor = .yellow
            }

            if averageRate >= 2 && averageRate < 3 {
                cell.averageRate.textColor = .red
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cells = journalModel.getStudents(journalId: journalId)

        if cells.count >= 25 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }

        return cells.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let students = journalModel.getStudents(journalId: journalId)
        
        let studentId = students[indexPath.row].id // не исключен фатал

        let destination = SubjectsTableViewController(shouldShowCloseButton: false, journalId: journalId, studentId: studentId)
        navigationController?.pushViewController(destination, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
        }

        journalModel.removeStudent(index: indexPath.row, journalId: journalId)
        tableView.deleteRows(at: [indexPath], with: .automatic)

        tableView.endUpdates()
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: NSLocalizedString("Delete", comment: "")) { [weak journalModel, journalId] (action, view, handler) in
            guard let model = journalModel else { return }

            tableView.beginUpdates()

            model.removeStudent(index: indexPath.row, journalId: journalId)
            tableView.deleteRows(at: [indexPath], with: .automatic)

            tableView.endUpdates()
        }

        let editAction = UIContextualAction(style: .normal,
                                            title: NSLocalizedString("Edit", comment: "")) { [weak self, journalModel, journalId] (action, view, handler) in
            let students = journalModel.getStudents(journalId: journalId)
            let student = students[indexPath.row]
            self?.editStudent(student: student)
        }

        editAction.backgroundColor = .gray
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false

        return configuration
    }

    private func setupNavigationBar() {
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

    private func editStudent(student: Student) {
        let viewController = CreateAndEditStudentViewController(state: .edit, student: student)
        let navigationController = UINavigationController(rootViewController: viewController)

        viewController.delegate = self

        present(navigationController, animated: true, completion: nil)
    }

    @objc private func addNewStudent() {
        let viewController = CreateAndEditStudentViewController(state: .create)
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.delegate = self
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: StudentsTableViewController + CreateStudentViewControllerDelegate

extension StudentsTableViewController: CreateAndEditStudentViewControllerDelegate {
    func editStudentDidClose(vc: CreateAndEditStudentViewController, student: Student, newFirstName: String, newSecondName: String) {
        journalModel.editStudent(student: student, journalId: journalId, newFirstName: newFirstName, newSecondName: newSecondName)

        tableView.reloadData()
        vc.dismiss(animated: true, completion: nil)
    }

    func createStudentDidClose(vc: CreateAndEditStudentViewController, didCreate student: Student) {
        journalModel.add(student: student, for: journalId)
        
        tableView.reloadData()
        vc.dismiss(animated: true, completion: nil)
    }
}
