import UIKit

final class StudentsTableViewController: UITableViewController {
    private let shouldShowCloseButton: Bool
    private let journalId: String
    private let cellId = "cellId"
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

        tableView.register(StudentCell.self, forCellReuseIdentifier: cellId)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! StudentCell
        // в prepare for reuse отправлять пустую ячейку

        let students = journalModel.getStudents(journalId: journalId)
        let studentId = students[indexPath.row].id

        let averageRate = journalModel.getAverageRate(studentId: studentId, journalId: journalId)

        if !students.isEmpty {
            cell.studentName.text = "\(students[indexPath.row].firstName) \(students[indexPath.row].secondName)"
            cell.averageRate.text = "\(averageRate)"

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

    private func insertCell(with model: Student) {
        journalModel.add(student: model, for: journalId)
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
