import UIKit

final class StudentCell: UITableViewCell {
    
    var studentsTableViewController: StudentsTableViewController?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    let label: UILabel = {
        let label = UILabel()

        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let removeButton: UIButton = {
        let button = UIButton()

        button.backgroundColor = .clear
        button.setTitle("Remove", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false

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

    func setupViews() {
        backgroundColor = .clear

        self.contentView.addSubview(removeButton)
        removeButton.addTarget(self, action: #selector(handleRemoveAction), for: .touchUpInside)

        NSLayoutConstraint.activate([
            removeButton.rightAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.rightAnchor, constant: -10),
            removeButton.widthAnchor.constraint(equalToConstant: 60)
        ])

        self.contentView.addSubview(editButton)
        editButton.addTarget(self, action: #selector(handleEditAction), for: .touchUpInside)

        NSLayoutConstraint.activate([
            editButton.rightAnchor.constraint(equalTo: removeButton.leftAnchor, constant: -10),
            editButton.widthAnchor.constraint(equalToConstant: 60)
        ])

        self.contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leftAnchor, constant: 20),
            label.rightAnchor.constraint(equalTo: editButton.leftAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 5),
            label.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
    }

    @objc
    func handleRemoveAction() {
        studentsTableViewController?.deleteCell(cell: self)
    }

    @objc
    func handleEditAction() {
        // TODO: edit group name
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
