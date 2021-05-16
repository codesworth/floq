//
//  DiscoveryCardFactory.swift
//  Floq
//
//  Created by ES-Shadrach on 16/05/2021.
//  Copyright © 2021 Arun Nagarajan. All rights reserved.
//

import Foundation

class DiscoveryCardFactory: DefaultCardFactory<ViewWrapperCell<DiscoveryCardView>> {
    let viewModel: DiscoveryCardViewModel
    init(viewModel: DiscoveryCardViewModel) {
        self.viewModel = viewModel
    }

    override public func getCellInstance(_ collectionView: UICollectionView,
                                         for indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: ViewWrapperCell<DiscoveryCardView> = collectionView.dequeueReusableCell(for: indexPath)
        cell.view.setup(with: viewModel)
        return cell
    }
}
