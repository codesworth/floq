import Foundation
import UIKit

public class PagedHorizontalCardContainerFactory: DefaultCardFactory<ViewWrapperCell<PagedHorizontalCardContainerView>> {
    public var cards: [CardFactory]

    private var cardHeight: CGFloat

    public init(cards: [CardFactory], cardHeight: CGFloat) {
        self.cards = cards
        self.cardHeight = cardHeight
    }

    override public func getCellInstance(_ collectionView: UICollectionView,
                                         for indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: ViewWrapperCell<PagedHorizontalCardContainerView> = collectionView.dequeueReusableCell(for: indexPath)
        cell.view.setup(cards: cards, with: cardHeight)
        return cell
    }
}
