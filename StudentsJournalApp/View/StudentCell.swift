import UIKit

final class StudentCell: UITableViewCell {
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

        return label
    }()

    private func setupViews() {
        backgroundColor = .clear

        self.contentView.addSubview(averageRate)
        averageRate.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            averageRate.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5),
            averageRate.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 5),
            averageRate.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            averageRate.widthAnchor.constraint(equalToConstant: 60)
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
}
