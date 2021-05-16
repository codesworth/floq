import Foundation
import Combine

protocol ProximalCliqRepositoryProtocol {
    func fetchProximalCliqs() -> AnyPublisher<[ProximalCliq], AppError>
}
