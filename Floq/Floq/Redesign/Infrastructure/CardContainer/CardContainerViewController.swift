import MagazineLayout
import UIKit



enum CardStyleConstants {
    static let topViewHeight: CGFloat = 0.0
    static let topViewLeftMargin: CGFloat = 16.0
    static let topViewRightMargin: CGFloat = 16.0
    static let topViewTopMargin: CGFloat = 0.0
    static let collectionViewTopMargin: CGFloat = 16.0
    static let collectionViewLeftMargin: CGFloat = 0.0
    static let collectionViewRightMargin: CGFloat = 0.0
    static let collectionViewBottomMargin: CGFloat = 0.0
    static let defaultVerticalSpacingBetweenCards: CGFloat = 12.0
    static let cardLeftMargin: CGFloat = 8.0
    static let cardRightMargin: CGFloat = 8.0
    static let cardTopMargin: CGFloat = 0.0
    static let cardBottomMargin: CGFloat = 0.0
}

open class CardContainerViewController: UIViewController,
    UICollectionViewDataSource, UICollectionViewDelegate
{
    public private(set) var collectionView: UICollectionView!
    private var topViewHeightConstraint: NSLayoutConstraint!
    private var topView: UIView!

    private var animatorCardCascade: AnimatorCollectionTable?

    private var verticalCardSpacing: CGFloat = CardStyleConstants.defaultVerticalSpacingBetweenCards

    public var viewModel: CardContainerViewModelProtocol?
    public var cards: [CardFactory]? {
        didSet {
            cards?.forEach { card in
                collectionView.register(card.cellType.self, forCellWithReuseIdentifier: card.cellType.identifier())
            }

            collectionView.reloadData()
        }
    }

    override public var title: String? {
        get {
            super.title ?? ""
        }

        set {
            super.title = newValue
        }
    }

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        initializeView()
        addConstraints()
        setupAnimators()
    }

    public convenience init(with viewModel: CardContainerViewModelProtocol,
                            cards: [CardFactory],
                            verticalCardSpacing: CGFloat?)
    {
        self.init(nibName: nil, bundle: nil)

        self.cards = cards
        self.viewModel = viewModel

        self.verticalCardSpacing = verticalCardSpacing ?? CardStyleConstants.defaultVerticalSpacingBetweenCards
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
    }

    public func showViewAtTop(view: UIView, height: CGFloat) {
        topView.addSubview(view)
        topViewHeightConstraint.constant = height
        view.pin(to: topView)
    }

    private func setupAnimators() {
        animatorCardCascade = AnimatorCollectionTable(
            animation: AnimationCollectionTableFactory.makeMoveUpWithFadeBounce(
                duration: 0.2,
                delayFactor: 0.1,
                completion: { [weak self] indexPath in
                    self?.animatorCardCascade?.animateDidEnded(indexPath: indexPath, in: self?.collectionView)
                }
            ),
            animateOnce: true,
            animateStopAtLastCell: true
        )
    }

    // MARK: UICollectionViewDataSource

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cards?.count ?? 0
    }

    open func collectionView(_ collectionView: UICollectionView,
                             cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = cards?[indexPath.row].getCellInstance(collectionView, for: indexPath)
        return cell ?? UICollectionViewCell()
    }

    // MARK: UICollectionViewDelegate

    public func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        animatorCardCascade?.animate(cell: cell, at: indexPath, in: collectionView)
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard previousTraitCollection != nil else { return }
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// Layout
extension CardContainerViewController {
    func initializeView() {
        view.backgroundColor = .white

        topView = UIView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.backgroundColor = .clear
        view.addSubview(topView)

        let collectionViewFlowLayout = MagazineLayout()

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
    }

    func addConstraints() {
        NSLayoutConstraint.activate(
            [
                topView.topAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.topAnchor,
                    constant: CardStyleConstants.topViewTopMargin
                ),
                topView.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                    constant: CardStyleConstants.topViewLeftMargin
                ),
                topView.trailingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                    constant: -CardStyleConstants.topViewRightMargin
                )
            ]
        )

        topViewHeightConstraint = topView.heightAnchor.constraint(equalToConstant: CardStyleConstants.topViewHeight)
        topViewHeightConstraint.isActive = true

        NSLayoutConstraint.activate(
            [
                collectionView.topAnchor.constraint(equalTo: topView.bottomAnchor),
                collectionView.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                    constant: CardStyleConstants.collectionViewLeftMargin
                ),
                collectionView.trailingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                    constant: -CardStyleConstants.collectionViewRightMargin
                ),
                collectionView.bottomAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                    constant: -CardStyleConstants.collectionViewBottomMargin
                )
            ]
        )
    }
}

extension CardContainerViewController: UICollectionViewDelegateMagazineLayout {
    public func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        insetsForItemsInSectionAtIndex _: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: CardStyleConstants.cardTopMargin,
            left: CardStyleConstants.cardLeftMargin,
            bottom: CardStyleConstants.cardBottomMargin,
            right: CardStyleConstants.cardRightMargin
        )
    }

    public func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        insetsForSectionAtIndex _: Int
    ) -> UIEdgeInsets { UIEdgeInsets(top: CardStyleConstants.collectionViewTopMargin, left: 0, bottom: 0, right: 0) }

    public func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        verticalSpacingForElementsInSectionAtIndex _: Int
    ) -> CGFloat { verticalCardSpacing }

    public func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        horizontalSpacingForItemsInSectionAtIndex _: Int
    ) -> CGFloat { 0 }

    public func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        visibilityModeForBackgroundInSectionAtIndex _: Int
    ) -> MagazineLayoutBackgroundVisibilityMode { .hidden }

    public func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        visibilityModeForFooterInSectionAtIndex _: Int
    ) -> MagazineLayoutFooterVisibilityMode { .hidden }

    public func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        visibilityModeForHeaderInSectionAtIndex _: Int
    ) -> MagazineLayoutHeaderVisibilityMode { .hidden }

    public func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeModeForItemAt _: IndexPath
    ) -> MagazineLayoutItemSizeMode {
        MagazineLayoutItemSizeMode(widthMode: .fullWidth(respectsHorizontalInsets: true), heightMode: .dynamic)
    }
}
