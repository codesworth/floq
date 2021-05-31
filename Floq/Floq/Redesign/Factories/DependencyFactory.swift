//
//  DependencyFactory.swift
//  Floq
//
//  Created by ES-Shadrach on 16/05/2021.
//  Copyright © 2021 Arun Nagarajan. All rights reserved.
//

import Foundation

class DependencyFactory{
    
    func proximalCliqRemoteDatasource() -> ProximalCliqRemoteDataSource { .init() }
    
    func userDataRepository() -> UserDataRepository { .init() }
    
    func userCliqDataRepository(uid: String) -> UserCliqDataRepository {
        .init(uid: uid)
    }
    
    func createCliqDataRepository(uid: String) -> CreateCliqDataRepository {
        .init(uid: uid)
    }
}
