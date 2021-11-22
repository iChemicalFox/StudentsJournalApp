import UIKit

final class JournalCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        textLabel?.text = nil // очистка тут и в других ячейках
    }

    private func configure(textColor: UIColor) {
        textLabel?.backgroundColor = .clear
        textLabel?.numberOfLines = 0
        textLabel?.textColor = textColor
        textLabel?.font = UIFont.systemFont(ofSize: 15)
    }

    private func setupViews() {
        backgroundColor = .white

        configure(textColor: .black)
    }
}
