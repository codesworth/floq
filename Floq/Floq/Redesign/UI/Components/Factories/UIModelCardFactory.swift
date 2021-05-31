//
//  UIModelCardFactory.swift
//  Floq
//
//  Created by ES-Shadrach on 22/05/2021.
//  Copyright © 2021 Arun Nagarajan. All rights reserved.
//

import Foundation

class NotificationCardFactory: DefaultCardFactory<ViewWrapperCell<NotificationCard>> {
    
    private let model: NotificationCard.UIModel
    
    init(with model: NotificationCard.UIModel){
        self.model = model
    }
    
    override func getCellInstance(_ collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ViewWrapperCell<NotificationCard> = collectionView.dequeueReusableCell(for: indexPath)
        cell.view.setup(with: model)
        
        return cell
    }
}


class AccountSettingsCardFactory: DefaultCardFactory<ViewWrapperCell<AccountSettingsCard>> {
    
    private let model: AccountSettingsCard.UIModel
    
    init(with model: AccountSettingsCard.UIModel){
        self.model = model
    }
    
    override func getCellInstance(_ collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ViewWrapperCell<AccountSettingsCard> = collectionView.dequeueReusableCell(for: indexPath)
        cell.view.setup(with: model)
        
        return cell
    }
}
