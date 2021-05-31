//
//  FloqHomeController.swift
//  Floq
//
//  Created by ES-Shadrach on 09/05/2021.
//  Copyright © 2021 Arun Nagarajan. All rights reserved.
//

import UIKit
import Combine

class FloqHomeController: CardContainerViewController {
    private enum Constants {
        static let topViewHeight: CGFloat = 60.0
        static let discoveryCardHeight: CGFloat = 206.0
        static let myCliqsCardHeight: CGFloat = 200.0
        static let cardsHeight: CGFloat = 206.0
    }
    
    private var cancellables = Set<AnyCancellable>()
    private var homeViewModel: FloqHomeViewModelProtocol { viewModel as! FloqHomeViewModelProtocol }

    public init() {
        fatalError("init() should never be used")
    }

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    convenience init(with viewModel: FloqHomeViewModelProtocol) {
        self.init(nibName: nil, bundle: nil)

        self.viewModel = viewModel
        self.cards = buildCards()
        setupUI()
        bind()

    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func bind() {
        homeViewModel.latestCliqImageReference.sink { [weak self] _ in
            self?.updateLayout()
        }.store(in: &cancellables)
        
        homeViewModel.myCliqCount.sink { [ weak self ] _ in
            self?.updateLayout()
        }.store(in: &cancellables)
    }

    private func setupUI() {
        title = "home_title".localize()
        let floaty = Floaty()
        floaty.buttonColor = .clear
        floaty.buttonImage = .icon_app_rounded
        
        floaty.addItem("Create a Cliq", icon:.icon_app, handler: { [weak self] item in
            let addvc = appDiContainer.createCliqViewController
            self?.navigationController?.pushViewController(addvc, animated: true)
        })
        
        floaty.addItem("Profile", icon:.placeholder, handler: { item in
            if let vc = UIStoryboard.main.instantiateViewController(withIdentifier: String(describing: UserProfileVC.self)) as? UserProfileVC{
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        
        view.addSubview(floaty)
        view.backgroundColor = .black
    }

    private func buildCards() -> [CardFactory] {
        let cards:[CardFactory] = [
            HorizontalCardContainerFactory(cards: [DiscoveryCardFactory(viewModel: homeViewModel.discoveryCardViewModel)], cardHeight: Constants.discoveryCardHeight),
            HorizontalCardContainerFactory(cards: [HorizontalCliqCardFactory(with: makeUserHomeCliqUiModel())], cardHeight: Constants.myCliqsCardHeight),
            HorizontalCardContainerFactory(cards: [
                NotificationCardFactory(with: .init(notifications: 10)),
                AccountSettingsCardFactory(with: .init(accountUid: UserDefaults.uid))
            ], cardHeight: Constants.cardsHeight)
        ]
        
        
        return cards
    }

    private func makeUserHomeCliqUiModel() -> HorizontalCliqCardView.UIModel {
        let count = homeViewModel.myCliqCount.value
        let trailing = count == 1 ? "cliqs_singular".localize() : "cliqs_plural".localize()
        let text = "\(count) \(trailing)"
        return .init(title: "my_cliqs".localize(), cliqsText: text, imageReference: homeViewModel.latestCliqImageReference.value, showEmpty: count == .zero) { [weak self ] in
            let myCliqsVc = appDiContainer.userCliqViewController
            self?.navigationController?.pushViewController(myCliqsVc, animated: true)
        }
    }
    
    private func updateLayout() {
        cards = buildCards()
    }


}
