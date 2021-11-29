import UIKit

extension UITableView {
    func register(_ cellType: AnyClass) {
        register(cellType, forCellReuseIdentifier: "\(cellType)")
    }

    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: "\(cellType)", for: indexPath) as? T else {
            fatalError("Didn't get cell for \(cellType)")
        }

        return cell
    }
}
