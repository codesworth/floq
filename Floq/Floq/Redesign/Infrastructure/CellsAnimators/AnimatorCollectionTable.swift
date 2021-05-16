import UIKit

public protocol UICollectionTableViewAnimatable {
    func isLastVisibleIndex(indexPath: IndexPath) -> Bool
}

public final class AnimatorCollectionTable {
    private var hasAnimatedAllCells = true
    private let animation: AnimationCollectionTable

    private var animateOnce = false
    private var animateStartedCache = [IndexPath]()
    private var animateEndedCache = [IndexPath]()

    private var animateStopAtLastCell = true

    public init(
        animation: @escaping AnimationCollectionTable,
        animateOnce: Bool = false,
        animateStopAtLastCell: Bool = true
    ) {
        self.animation = animation
        self.animateOnce = animateOnce
        self.animateStopAtLastCell = animateStopAtLastCell
    }

    public func reset() {
        animateStartedCache.removeAll(keepingCapacity: true)
        animateEndedCache.removeAll(keepingCapacity: true)
    }

    public func animateDidEnded(indexPath: IndexPath, in collectionTableView: UICollectionTableViewAnimatable?) {
        animateEndedCache.append(indexPath)

        guard collectionTableView != nil else {
            return
        }

        if animateStopAtLastCell {
            hasAnimatedAllCells = !collectionTableView!.isLastVisibleIndex(indexPath: indexPath)
        }
    }

    public func stopAllCellAnimation() {
        hasAnimatedAllCells = true
    }

    public func animate(
        cell: UIView,
        at indexPath: IndexPath,
        in collectionTableView: UIView
    ) {
        guard hasAnimatedAllCells else { return }

        if animateOnce,
           animateStartedCache.contains(indexPath),
           animateEndedCache.contains(indexPath) { return }

        animateStartedCache.append(indexPath)
        animation(cell, indexPath, collectionTableView)
    }
}
