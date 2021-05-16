//
//  LayoutProperty.swift
//  QuotesMaker
//
//  Created by Shadrach Mensah on 27/03/2019.
//  Copyright © 2019 Shadrach Mensah. All rights reserved.
//

import UIKit


public struct LayoutProperty<Anchor:LayoutAnchor> {
    fileprivate let anchor:Anchor
}

public class LayoutProxy{
    
    public lazy var leading = property(with: view.leadingAnchor)
    public lazy var trailing = property(with: view.trailingAnchor)
    public lazy var top = property(with: view.topAnchor)
    public lazy var bottom = property(with: view.bottomAnchor)
    public lazy var width = property(with: view.widthAnchor)
    public lazy var height = property(with: view.heightAnchor)
    public lazy var centerX = property(with: view.centerXAnchor)
    public lazy var centerY = property(with: view.centerYAnchor)
    private let view: UIView
    
    public init(view: UIView) {
        self.view = view
    }
    
    private func property<A: LayoutAnchor>(with anchor: A) -> LayoutProperty<A> {
        return LayoutProperty(anchor: anchor)
    }
    
    
    
}


extension LayoutProperty {
    
    
    @discardableResult
    public func equal(to otherAnchor: Anchor, offsetBy constant: CGFloat = 0)->NSLayoutConstraint {
        let constraint = anchor.constraint(equalTo: otherAnchor,
                          constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func greaterThanOrEqual(to otherAnchor: Anchor,
                            offsetBy constant: CGFloat = 0)->NSLayoutConstraint {
        let constraint = anchor.constraint(greaterThanOrEqualTo: otherAnchor,
                          constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func lessThanOrEqual(to otherAnchor: Anchor,
                         offsetBy constant: CGFloat = 0)->NSLayoutConstraint {
        let constraint = anchor.constraint(lessThanOrEqualTo: otherAnchor,
                          constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func equal(to constant:CGFloat)->NSLayoutConstraint{
        let constraint = anchor.constraint(equalToConstant: constant)
        constraint.isActive = true
        return constraint
    }
    
    
}
