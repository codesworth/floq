import Foundation
import UIKit

public extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(
        withReuseIdentifier identifier: String = T.identifier(),
        for indexPath: IndexPath
    ) -> T {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: identifier,
            for: indexPath
        ) as? T else {
            fatalError("Unable to dequeue collection view cell with identifier: \(identifier)")
        }
        return cell
    }

    func registerForReuse(_ cellClass: UICollectionViewCell.Type) {
        register(cellClass.self, forCellWithReuseIdentifier: cellClass.identifier())
    }

    func registerForReuse(
        _ cellClass: UICollectionViewCell.Type,
        for supplementaryViewOfKind: String
    ) {
        register(
            cellClass.self,
            forSupplementaryViewOfKind: supplementaryViewOfKind,
            withReuseIdentifier: cellClass.identifier()
        )
    }
}

public extension UICollectionReusableView {
    static func registerNib(in collectionView: UICollectionView,
                            for supplementaryViewOfKind: String,
                            from bundle: Bundle? = nil)
    {
        collectionView.register(
            UINib(nibName: Self.identifier(), bundle: bundle),
            forSupplementaryViewOfKind: supplementaryViewOfKind,
            withReuseIdentifier: Self.identifier()
        )
    }
}
