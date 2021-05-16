
import Foundation
import UIKit

public class HorizontalCardContainerFactory: DefaultCardFactory<ViewWrapperCell<HorizontalCardContainerView>> {
    public var cards: [CardFactory]

    private var cardHeight: CGFloat

    public init(cards: [CardFactory], cardHeight: CGFloat) {
        self.cards = cards
        self.cardHeight = cardHeight
    }

    override public func getCellInstance(_ collectionView: UICollectionView,
                                         for indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: ViewWrapperCell<HorizontalCardContainerView> = collectionView.dequeueReusableCell(for: indexPath)
        cell.view.setup(cards: cards, with: cardHeight)
        return cell
    }
}
