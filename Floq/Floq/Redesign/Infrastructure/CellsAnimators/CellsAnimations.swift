import UIKit

private enum CellsAnimations {}

public typealias AnimationCollectionTable = (_ cell: UIView, _ indexPath: IndexPath, _ collectionTable: UIView) -> Void

public enum AnimationCollectionTableFactory {
    public static func makeMoveUpWithFadeBounce(
        duration: TimeInterval,
        delayFactor: Double,
        cellLayerzPosition: CGFloat? = nil,
        completion: ((IndexPath) -> Void)?
    ) -> AnimationCollectionTable {
        let animation: AnimationCollectionTable = { cell, indexPath, _ in
            cell.transform = CGAffineTransform(translationX: 0, y: 10)
            cell.alpha = 0

            if let zPosition = cellLayerzPosition {
                cell.layer.zPosition = zPosition
            }

            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 5,
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                    cell.alpha = 1
                },
                completion: { _ in
                    completion?(indexPath)
                }
            )
        }

        return animation
    }
}
