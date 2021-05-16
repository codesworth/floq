//
//  FLoqHomeViewModel.swift
//  Floq
//
//  Created by ES-Shadrach on 09/05/2021.
//  Copyright © 2021 Arun Nagarajan. All rights reserved.
//

import Foundation

protocol FloqHomeViewModelProtocol : CardContainerViewModelProtocol {
    var discoveryCardViewModel: DiscoveryCardViewModel { get }
}

class FloqHomeViewModel: FloqHomeViewModelProtocol {
    struct Dependencies {
        let discoveryViewModel: DiscoveryCardViewModel
    }
    
    var discoveryCardViewModel: DiscoveryCardViewModel
    
    init(dependencies: Dependencies) {
        self.discoveryCardViewModel = dependencies.discoveryViewModel
    }
}
