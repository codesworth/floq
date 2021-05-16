//
//  File.swift
//  Floq
//
//  Created by ES-Shadrach on 16/05/2021.
//  Copyright © 2021 Arun Nagarajan. All rights reserved.
//

import Foundation

class ViewModelFactory{
    
    func discoveryCardViewModel(
        datasource: ProximalCliqRemoteDataSource,
        coordinate: CLLocationCoordinate2D?
    ) -> DiscoveryCardViewModel {
        .init(datasource: datasource, coordinate: coordinate)
    }
    
    func floqHomeViewModel(
        discoveryViewModel: DiscoveryCardViewModel
    ) -> FloqHomeViewModelProtocol {
        FloqHomeViewModel(
            dependencies: .init(
                discoveryViewModel: discoveryViewModel)
        )
    }
}
