import UIKit

final class ValueCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render(title: String, value: String) {
        textLabel?.text = title
        detailTextLabel?.text = value
    }

    func setValueColor(_ color: UIColor) {
        detailTextLabel?.textColor = color
    }

    func setLabelColor(_ color: UIColor) {
        textLabel?.textColor = color
    }

    private func configure(label: UILabel, textColor: UIColor) {
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textColor = textColor
        label.font = UIFont.systemFont(ofSize: 15)
    }

    private func setupViews() {
        backgroundColor = .white

        configure(label: textLabel!, textColor: .black)
        configure(label: detailTextLabel!, textColor: .gray)
    }
}
