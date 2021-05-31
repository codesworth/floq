//
//  FloqDIContainer.swift
//  Floq
//
//  Created by ES-Shadrach on 16/05/2021.
//  Copyright © 2021 Arun Nagarajan. All rights reserved.
//

import Foundation

var appDiContainer: FloqDIContainer { .container }

class FloqDIContainer: NSObject {
    static let container = FloqDIContainer()
    
    private var dependencyFactory = DependencyFactory()
    private var viewModelFactory = ViewModelFactory()
    private var viewControllerFactory = ViewControllerFactory()
    var locationManager = LocationManager()
    private var userId: String { UserDefaults.uid }
    private lazy var globalCliqRepository: UserCliqDataRepository = {
        dependencyFactory.userCliqDataRepository(uid: userId)
    }()
    
    private override init() { super.init() }
    
    var discoveryCardViewModel: DiscoveryCardViewModel {
        viewModelFactory.discoveryCardViewModel(datasource: dependencyFactory.proximalCliqRemoteDatasource(),
            coordinate:locationManager.coordinate)
    }
    
    var homeViewController: FloqHomeController {
        viewControllerFactory.makeHomeViewController(
            viewModel: viewModelFactory.floqHomeViewModel(
                discoveryViewModel: discoveryCardViewModel,
                userRepository: dependencyFactory.userDataRepository(),
                userCliqRepository: globalCliqRepository
            )
        )
    }
    
    var userCliqViewController: UserCliqViewController {
        viewControllerFactory.makeUserCliqViewController(
            viewModel: viewModelFactory.userCliqViewModel(
                userCliqRepository: globalCliqRepository
            )
        )
    }
    
    var createCliqViewController: CreateCliqViewController {
        viewControllerFactory.makeCreateCliqviewController(
            viewModel: viewModelFactory.createCliqViewModel(repository: dependencyFactory.createCliqDataRepository(uid: userId),
                                                            locationManager: locationManager)
        )
    }
    
}
