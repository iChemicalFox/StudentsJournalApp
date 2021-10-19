import UIKit

final class StudentsTableViewController: UITableViewController {
    let isPresented: Bool
    let cellId = "cellId"
    var items = [Student]()

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

        tableView.register(StudentCell.self, forCellReuseIdentifier: cellId)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? StudentCell else {
            return UITableViewCell()
        }

        cell.label.text = "\(items[indexPath.row].firstName) \(items[indexPath.row].secondName)"
        cell.studentsTableViewController = self

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    private func setupNavigationBar() {
        navigationItem.title = "Students"

        if isPresented {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                title: "close",
                image: nil,
                primaryAction: UIAction(handler: { [weak self] _ in
                    self?.dismiss(animated: true, completion: nil)
                }), menu: nil)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                target: self,
                                                                action: #selector(addNewStudent))
        }
    }

    func insertCell(with model: Student) {
        items.append(model)
    }

    func deleteCell(cell: UITableViewCell) {
        if let deletionIndexPath = tableView.indexPath(for: cell) {
            items.remove(at: deletionIndexPath.row)
            tableView.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
    }

    @objc
    func addNewStudent() {
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
