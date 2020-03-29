//
//  Insetable.swift
//  Floq
//
//  Created by OZE-Shadrach on 3/28/20.
//  Copyright © 2020 Arun Nagarajan. All rights reserved.
//

import UIKit


protocol Insetable {
    
    var horizontalInset:CGFloat {get}
    var verticalInset:CGFloat {get}
}



extension Insetable{
    /// An inset of 16
    var horizontalInset:CGFloat {
        return 16
    }
    
    /// An inset of 16
    var verticalInset:CGFloat {
        return 16
    }
    
    var doubleVerticalInset:CGFloat{
        return 2 * verticalInset
    }
    
    var doubleHorizontalInset:CGFloat{
        return 2 * horizontalInset
    }
    
    func verticalInsetBy(_ value:CGFloat)->CGFloat{
        return verticalInset * value
    }
    
    func horizontalInsetBy(_ value:CGFloat)->CGFloat{
        return horizontalInset * value
    }
    
}
