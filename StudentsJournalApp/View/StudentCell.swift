import UIKit

final class StudentCell: UITableViewCell {
    
    var studentsTableViewController: StudentsTableViewController?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let studentName: UILabel = {
        let label = UILabel()

        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)

        return label
    }()

    let averageRate: UILabel = {
        let label = UILabel()

        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textColor = .purple
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "0,00" // временно

        return label
    }()

    let removeButton: UIButton = {
        let button = UIButton()

        button.backgroundColor = .clear
        button.setTitle("Remove", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)

        return button
    }()

    let editButton: UIButton = {
        let button = UIButton()

        button.backgroundColor = .clear
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private func setupViews() {
        backgroundColor = .clear

        self.contentView.addSubview(removeButton)
        removeButton.addTarget(self, action: #selector(handleRemoveAction), for: .touchUpInside)
        removeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            removeButton.rightAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.rightAnchor, constant: -10),
            removeButton.widthAnchor.constraint(equalToConstant: 60)
        ])

        self.contentView.addSubview(editButton)
        editButton.addTarget(self, action: #selector(handleEditAction), for: .touchUpInside)
        editButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            editButton.rightAnchor.constraint(equalTo: removeButton.leftAnchor, constant: -10),
            editButton.widthAnchor.constraint(equalToConstant: 60)
        ])

        self.contentView.addSubview(averageRate)
        averageRate.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            averageRate.rightAnchor.constraint(equalTo: editButton.leftAnchor, constant: -10),
            averageRate.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 5),
            averageRate.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            editButton.widthAnchor.constraint(equalToConstant: 30)
        ])

        self.contentView.addSubview(studentName)
        studentName.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            studentName.leftAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leftAnchor, constant: 20),
            studentName.rightAnchor.constraint(equalTo: averageRate.leftAnchor, constant: -10),
            studentName.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 5),
            studentName.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
    }

    @objc private func handleRemoveAction() {
        studentsTableViewController?.deleteCell(cell: self)
    }

    @objc private func handleEditAction() {
        // TODO: edit student name
    }
}
