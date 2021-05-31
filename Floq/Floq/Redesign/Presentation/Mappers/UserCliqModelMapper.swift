//
//  UserCliqModelMaapper.swift
//  Floq
//
//  Created by ES-Shadrach on 22/05/2021.
//  Copyright © 2021 Arun Nagarajan. All rights reserved.
//

import Foundation


class UserCliqModelMaapper {
    func map(model: UserCliqPresentationModel) -> UserCliqCard.UIModel {
        let followsText = model.followers == 1 ? "\(model.followers) \("cliq_follower".localize())" : "\(model.followers) \("cliq_follower".localize())"
        return .init(title: model.cliqTitle, cliqsText: followsText, messages: model.messageCount, imageReference: model.imageReference)
    }
    
    func map(model: UserCliqPresentationModel) -> HorizontalCliqCardView.UIModel {
        let followsText = model.followers == 1 ? "\(model.followers) \("cliq_follower".localize())" : "\(model.followers) \("cliq_follower".localize())"
        return .init(title: model.cliqTitle, cliqsText: followsText, imageReference: model.imageReference)
    }
    
    func map(model: CliqDataModel) -> UserCliqPresentationModel {
        .init(id: model.id, cliqTitle: model.name.capitalized, followers: model.followers.count, messageCount: 5, imageReference: model.fileID, isLive: [true, false].randomElement()!, timestamp: model.timestamp)
    }
}
