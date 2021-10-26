import UIKit

final class SubjectCell: UITableViewCell {
    var subjectsTableViewController: SubjectsTableViewController?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let subjectName: UILabel = {
        let label = UILabel()

        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)

        return label
    }()

    let subjectRating: UILabel = {
        let label = UILabel()

        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textColor = .purple
        label.font = UIFont.systemFont(ofSize: 15)

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

        self.contentView.addSubview(subjectRating)
        subjectRating.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            subjectRating.rightAnchor.constraint(equalTo: editButton.leftAnchor, constant: -10),
            subjectRating.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 5),
            subjectRating.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            editButton.widthAnchor.constraint(equalToConstant: 30)
        ])

        self.contentView.addSubview(subjectName)
        subjectName.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            subjectName.leftAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leftAnchor, constant: 20),
            subjectName.rightAnchor.constraint(equalTo: subjectRating.leftAnchor, constant: -10),
            subjectName.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 5),
            subjectName.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
    }

    @objc private func handleRemoveAction() {
        subjectsTableViewController?.deleteCell(cell: self)
    }

    @objc private func handleEditAction() {
        // TODO: edit rating
    }
}
