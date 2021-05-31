//
//  FLoqHomeViewModel.swift
//  Floq
//
//  Created by ES-Shadrach on 09/05/2021.
//  Copyright © 2021 Arun Nagarajan. All rights reserved.
//

import Foundation
import Combine


protocol FloqHomeViewModelProtocol : CardContainerViewModelProtocol {
    var discoveryCardViewModel: DiscoveryCardViewModel { get }
    var myCliqCount: CurrentValueSubject<Int, Never> { get set }
    var latestCliqImageReference: CurrentValueSubject<String?, Never> { get set }
}

class FloqHomeViewModel: FloqHomeViewModelProtocol {
    
    struct Dependencies {
        let discoveryViewModel: DiscoveryCardViewModel
        let userRepository: UserDataRepository
        let userCliqRepository: UserCliqDataRepository
    }
    
    private var cancellables = Set<AnyCancellable>()
    var discoveryCardViewModel: DiscoveryCardViewModel
    var myCliqCount: CurrentValueSubject<Int, Never>
    var latestCliqImageReference: CurrentValueSubject<String?, Never>
    private let userDataRepository: UserDataRepository
    private let userCliqDataRepository: UserCliqDataRepository
    
    init(dependencies: Dependencies) {
        self.discoveryCardViewModel = dependencies.discoveryViewModel
        self.userDataRepository = dependencies.userRepository
        self.userCliqDataRepository = dependencies.userCliqRepository
        if let value = userDataRepository.user?.cliqs {
            myCliqCount = .init(value)
        }else { myCliqCount = .init(.zero) }
        latestCliqImageReference = .init(userCliqDataRepository.latastCliq?.fileID)
        
        loadData()
    }
    
    func loadData(){
        userDataRepository.$user.sink { [ weak self ] user in
            guard let self = self, let count = user?.cliqs else { return }
            self.myCliqCount.send(count)
        }.store(in: &cancellables)
        
        userCliqDataRepository.$latastCliq.sink { [weak self] latest in
            guard let self = self, let file = latest?.fileID else { return }
            self.latestCliqImageReference.send(file)
        }.store(in: &cancellables)
    }
}
