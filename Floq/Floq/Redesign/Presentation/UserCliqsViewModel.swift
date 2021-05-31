import Foundation
import Combine

protocol UserCliqViewModelProtocol {
    var userCliqs: CurrentValueSubject<[UserCliqPresentationModel], Never> { get set}
    
}


class UserCliqsViewModel: UserCliqViewModelProtocol {
    
    private var cancellables = Set<AnyCancellable>()
    private let userCliqRepository: UserCliqDataRepository
    private let mapper = UserCliqModelMaapper()
    var userCliqs: CurrentValueSubject<[UserCliqPresentationModel], Never> = .init([])
    
    init(userRepository: UserCliqDataRepository) {
        self.userCliqRepository = userRepository
        update(cliqs: userRepository.userCliqs)
        bind()
    }
    
    private func bind(){
        userCliqRepository.$userCliqs.sink { [ weak self ] cliqs in
            self?.update(cliqs: cliqs)
        }.store(in: &cancellables)
    }
    
    private func update(cliqs: Set<CliqDataModel>){
        let presentationModels = cliqs.map(mapper.map(model:))
        var updatable = Set(userCliqs.value)
        presentationModels.forEach { updatable.update(with: $0) }
        userCliqs.send(updatable.sorted().reversed())
    }
}
