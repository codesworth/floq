//
//  UIView+Additions.swift
//  Floq
//
//  Created by ES-Shadrach on 09/05/2021.
//  Copyright © 2021 Arun Nagarajan. All rights reserved.
//

import UIKit

public extension UIView {
    func pin(to view: UIView, insets: UIEdgeInsets = .zero) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right),
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
        ])
    }

    func pinToSuperview(withInsets insets: UIEdgeInsets = UIEdgeInsets()) {
        guard let superview = superview else {
            return
        }

        pin(to: superview, insets: insets)
    }
    
    func addCardStyle(){
        self.dropCorner(5)
        dropShadow(3, color: .charcoal, 0.5, .init(width: 0, height: 2))
    }
    
    func addOverlayCardStyle(){
        let view = PassthroughView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.pin(to: self)
    }
}
