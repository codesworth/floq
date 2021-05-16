import Foundation
import UIKit

public protocol Identifiable {
    static func identifier() -> String
}

public extension Identifiable {
    static func identifier() -> String {
        String(describing: self)
    }
}

extension UIView: Identifiable {}

public extension UICollectionViewCell {
    static func registerNib(in collectionView: UICollectionView, from bundle: Bundle? = nil) {
        collectionView.register(
            UINib(nibName: Self.identifier(), bundle: bundle),
            forCellWithReuseIdentifier: Self.identifier()
        )
    }
}

public extension UITableViewHeaderFooterView {
    static func registerNib(in tableView: UITableView, from bundle: Bundle? = nil) {
        tableView.register(
            UINib(
                nibName: Self.identifier(),
                bundle: bundle
            ),
            forHeaderFooterViewReuseIdentifier: Self.identifier()
        )
    }
}

public extension UITableViewCell {
    static func registerNib(in tableView: UITableView, from bundle: Bundle? = nil) {
        tableView.register(
            UINib(
                nibName: Self.identifier(),
                bundle: bundle
            ),
            forCellReuseIdentifier: Self.identifier()
        )
    }
}
