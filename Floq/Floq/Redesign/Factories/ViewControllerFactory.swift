//
//  ViewControllerFactory.swift
//  Floq
//
//  Created by ES-Shadrach on 16/05/2021.
//  Copyright © 2021 Arun Nagarajan. All rights reserved.
//

import Foundation

class ViewControllerFactory {
    
    func makeHomeViewController(viewModel: FloqHomeViewModelProtocol) -> FloqHomeController {
        .init(with: viewModel)
    }
}
