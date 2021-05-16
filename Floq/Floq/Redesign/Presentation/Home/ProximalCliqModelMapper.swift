//
//  ProximalCliqModelMapper.swift
//  Floq
//
//  Created by ES-Shadrach on 16/05/2021.
//  Copyright © 2021 Arun Nagarajan. All rights reserved.
//

import Foundation

class ProximalCliqModelMapper {
    
    func map(model: ProximalCliqDataModel) -> ProximalCliq {
        .init(id: model.id, coordinate: model.location?.coordinate ?? .init(), fileID: model.fileID, name: model.name, creatorUid: model.creatorUid, creatorName: model.creatorName, followers: model.followers, timestamp: model.timestamp, joined: model.joined)
    }
}
