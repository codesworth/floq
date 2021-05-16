//
//  ProximalCliq.swift
//  Floq
//
//  Created by ES-Shadrach on 09/05/2021.
//  Copyright © 2021 Arun Nagarajan. All rights reserved.
//

import Foundation

struct ProximalCliq {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let fileID:String
    let name:String
    let creatorUid:String
    let creatorName:String
    let followers: Set<String>
    let timestamp:Date
    let joined:Bool
}

extension ProximalCliq: Equatable, Hashable {
    static func ==(lhs:Self, rhs:Self) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
