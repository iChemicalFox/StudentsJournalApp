import UIKit

final class SubjectCell: UITableViewCell {
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

    private func setupViews() {
        backgroundColor = .clear

        self.contentView.addSubview(subjectRating)
        subjectRating.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            subjectRating.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5),
            subjectRating.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 5),
            subjectRating.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            subjectRating.widthAnchor.constraint(equalToConstant: 20)
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
}
