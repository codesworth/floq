import Foundation
import UIKit

public final class HorizontalCardContainerView: UIView {
    private enum Constants {
        static let defaultCollectionViewHeight: CGFloat = 100
    }

    private var collectionView: UICollectionView!
    private var collectionViewHeightConstraint: NSLayoutConstraint!

    private var cards: [CardFactory] = []

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        addConstraints()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("This class is not enabled for nib loading")
    }

    public func setup(cards: [CardFactory], with cardHeight: CGFloat? = nil) {
        self.cards = cards

        cards.forEach { card in
            collectionView.register(card.cellType.self, forCellWithReuseIdentifier: card.cellType.identifier())
        }

        collectionViewHeightConstraint.constant = cardHeight ?? Constants.defaultCollectionViewHeight

        collectionView.reloadData()
    }
}

extension HorizontalCardContainerView: UICollectionViewDelegate, UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        return cards[indexPath.row].getCellInstance(collectionView, for: indexPath)
    }
}

// Layout
extension HorizontalCardContainerView {
    func initializeView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear

        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionViewFlowLayout.scrollDirection = .horizontal

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.clipsToBounds = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
    }

    func addConstraints() {
        collectionView.pin(to: self)
        collectionViewHeightConstraint = collectionView.heightAnchor
            .constraint(equalToConstant: Constants.defaultCollectionViewHeight)
        collectionViewHeightConstraint.isActive = true
    }
}
