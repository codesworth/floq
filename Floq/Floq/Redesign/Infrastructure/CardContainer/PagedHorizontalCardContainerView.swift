import Foundation
import UIKit

public final class PagedHorizontalCardContainerView: UIView {
    private enum Constants {
        static let defaultCollectionViewHeight: CGFloat = 100.0
        static let pagingControlHeight: CGFloat = 4.0
        static let pagingControlTopMargin: CGFloat = 13.0
        static let currentPageIndicatorTintColor: UIColor = .gray
        static let pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.3)
    }

    private var collectionView: UICollectionView!
    private var collectionViewHeightConstraint: NSLayoutConstraint!
    private var pageControl: UIPageControl!

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

        pageControl.numberOfPages = cards.count
    }

    @objc private func pageControlValueChangedAction(_ sender: UIPageControl) {
        collectionView.isPagingEnabled = false
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: IndexPath(row: sender.currentPage, section: 0), at: .left, animated: true)
        collectionView.isPagingEnabled = true
    }
}

extension PagedHorizontalCardContainerView: UICollectionViewDelegate, UICollectionViewDataSource,
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

extension PagedHorizontalCardContainerView: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint) {
            pageControl.currentPage = visibleIndexPath.row
        }
    }
}

// Layout
extension PagedHorizontalCardContainerView {
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
        collectionView.isPagingEnabled = true

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)

        pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = Constants.currentPageIndicatorTintColor
        pageControl.pageIndicatorTintColor = Constants.pageIndicatorTintColor
        pageControl.addTarget(self, action: #selector(pageControlValueChangedAction(_:)), for: .valueChanged)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pageControl)
    }

    func addConstraints() {
        NSLayoutConstraint.activate(
            [
                collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                collectionView.topAnchor.constraint(equalTo: topAnchor)
            ]
        )
        collectionViewHeightConstraint = collectionView.heightAnchor
            .constraint(equalToConstant: Constants.defaultCollectionViewHeight)
        collectionViewHeightConstraint.isActive = true

        NSLayoutConstraint.activate(
            [
                pageControl.leadingAnchor.constraint(equalTo: leadingAnchor),
                pageControl.trailingAnchor.constraint(equalTo: trailingAnchor),
                pageControl.bottomAnchor.constraint(equalTo: bottomAnchor),
                pageControl.topAnchor.constraint(
                    equalTo: collectionView.bottomAnchor,
                    constant: Constants.pagingControlTopMargin
                ),
                pageControl.heightAnchor.constraint(equalToConstant: Constants.pagingControlHeight)
            ]
        )
    }
}
