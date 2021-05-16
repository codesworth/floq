//
//  GetProximalCliqsUseCase.swift
//  Floq
//
//  Created by ES-Shadrach on 09/05/2021.
//  Copyright © 2021 Arun Nagarajan. All rights reserved.
//

import Foundation
import Combine

protocol GetProximalCliqsUseCaseProtocol {
    func execute() -> AnyPublisher<[FLCliqItem], AppError>
}

