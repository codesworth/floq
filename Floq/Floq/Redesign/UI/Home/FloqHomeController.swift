//
//  FloqHomeController.swift
//  Floq
//
//  Created by ES-Shadrach on 09/05/2021.
//  Copyright © 2021 Arun Nagarajan. All rights reserved.
//

import UIKit

class FloqHomeController: CardContainerViewController {
    private enum Constants {
        static let topViewHeight: CGFloat = 60.0
        static let discoveryCardHeight: CGFloat = 207.0
        static let activityCardHeight: CGFloat = 142.0
        static let readinessCardHeight: CGFloat = 228.0
    }
    
    private var homeViewModel: FloqHomeViewModelProtocol { viewModel as! FloqHomeViewModelProtocol }

    private var cardFactories: [CardFactory] {
        return [
            HorizontalCardContainerFactory(cards: [DiscoveryCardFactory(viewModel: homeViewModel.discoveryCardViewModel)], cardHeight: Constants.discoveryCardHeight)
        ]
    }

    public init() {
        fatalError("init() should never be used")
    }

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    convenience init(with viewModel: FloqHomeViewModelProtocol) {
        self.init(nibName: nil, bundle: nil)

        self.viewModel = viewModel
        self.cards = cardFactories

        bind()
        setupUI()

    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        view.backgroundColor = .black
        title = "home_title".localize()
    }


    private func updateLayout() {
        cards = cardFactories
    }

    private var floqViewModel: FloqHomeViewModelProtocol? {
        return viewModel as? FloqHomeViewModelProtocol
    }

    private func bind() {
        
    }

}
