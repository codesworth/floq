//
//  AppError.swift
//  Floq
//
//  Created by ES-Shadrach on 09/05/2021.
//  Copyright © 2021 Arun Nagarajan. All rights reserved.
//

import Foundation

struct AppError: Error, CustomStringConvertible, CustomDebugStringConvertible {
    
    enum ErrorType {
        case locationUnAvailble, noNetworkConnection, other
    }
    
    var errorMessage: String
    var errorType: ErrorType = .other
    
    var description: String {
        errorMessage
    }
    
    var debugDescription: String {
        "🆘🆘 Error occurred with message\(errorMessage)"
    }
}
