import Foundation
import UIKit

public protocol CardFactory {
    var cellType: UICollectionViewCell.Type { get set }
    func getCellInstance(_ collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell
}

open class DefaultCardFactory<T: UICollectionViewCell>: CardFactory {
    public var cellType: UICollectionViewCell.Type = T.self
    public init() {}
    open func getCellInstance(_ collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        let cell: T = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
}
