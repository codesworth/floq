import UIKit

public extension UICollectionView {
    func isLastVisibleCell(at presentingIndexPath: IndexPath) -> Bool {
        guard let lastVisbleIndexPath = indexPathsForVisibleItems.sorted().last else {
            return false
        }
        return presentingIndexPath == lastVisbleIndexPath
    }
}

extension UICollectionView: UICollectionTableViewAnimatable {
    public func isLastVisibleIndex(indexPath: IndexPath) -> Bool {
        isLastVisibleCell(at: indexPath)
    }
}
