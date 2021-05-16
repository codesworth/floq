//
//  String+Localize.swift
//  Floq
//
//  Created by ES-Shadrach on 16/05/2021.
//  Copyright © 2021 Arun Nagarajan. All rights reserved.
//

import Foundation

extension String {
    func localize() -> String{
        Bundle.main.localizedString(forKey: self, value: self.uppercased(), table: nil)
    }
}
