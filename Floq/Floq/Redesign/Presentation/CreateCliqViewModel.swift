import Foundation
import Combine


protocol CreateCliqViewModelProtocol {
    var createCliqListener: PassthroughSubject<Bool,AppError> { get set }
    func createCliq(name: String, coverImageData: Data)
}

class CreateCliqViewModel: CreateCliqViewModelProtocol {
    
    private let repository: CreateCliqDataRepository
    private let locationManager: LocationManager
    private let mapper = CreateCliqMapper()
    
    var createCliqListener: PassthroughSubject<Bool,AppError> = .init()
    
    
    init(
        repository: CreateCliqDataRepository,
        locationManager: LocationManager
    ) {
        self.repository = repository
        self.locationManager = locationManager
    }
    
    func createCliq(name: String, coverImageData: Data){
        guard let coordinate = locationManager.coordinate else {
            createCliqListener.send(completion: .failure(.init(errorMessage: "Unable to access current location. Please enable location services", errorType: .locationUnAvailble)))
            return
        }
        let cliq = CreateCliqPresentationModel(
            name: name,
            coordinate: coordinate, imageData: coverImageData)
        repository.create(
            cliq: mapper.map(model: cliq)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                self.createCliqListener.send(true)
            case .failure(let err):
                self.createCliqListener.send(completion: .failure(err))
            }
        }
    }
}
