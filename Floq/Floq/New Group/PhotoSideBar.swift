//
//  PhotoSideBar.swift
//  Floq
//
//  Created by OZE-Shadrach on 3/28/20.
//  Copyright © 2020 Arun Nagarajan. All rights reserved.
//

import UIKit


class PhotoSideBar:UIView,Insetable{
    
    var actionForAccountButton:CompletionHandlers.simpleBlock?
    var actionForDeleteButton:CompletionHandlers.simpleBlock?
    var actionForDetailButton:CompletionHandlers.simpleBlock?
    
    var actionForLogoutButton:CompletionHandlers.simpleBlock?
    
    private var isShowing = false
    
    lazy var accountButton:UIButton = {[unowned self] in
        let but = UIButton(frame:.zero)
        but.setAttributedTitle("Account".attributing([.textColor(.white),.font(.systemFont(ofSize: 16, weight: .regular)), .alignment(.left)]), for: .normal)
        but.contentMode = .scaleAspectFit
        but.titleLabel?.textAlignment = .left
        but.addTarget(self, action: #selector(tabPressed(_:)), for: .touchUpInside)
        return but
        }()
    
    lazy var deletebutton:UIButton = {[unowned self] in
        let but = UIButton(frame:.zero)
        but.setAttributedTitle("Delete Photos".attributing([.textColor(.white),.font(.systemFont(ofSize: 16, weight: .regular)), .alignment(.left)]), for: .normal)
        but.contentMode = .scaleAspectFit
        but.titleLabel?.textAlignment = .left
        but.addTarget(self, action: #selector(tabPressed(_:)), for: .touchUpInside)
        return but
        }()
    
    lazy var detailButton:UIButton = {[unowned self] in
        let but = UIButton(frame:.zero)
        but.setAttributedTitle("Users".attributing([.textColor(.white),.font(.systemFont(ofSize: 16, weight: .regular)), .alignment(.left)]), for: .normal)
        but.contentMode = .scaleAspectFit
        but.titleLabel?.textAlignment = .left
        but.addTarget(self, action: #selector(tabPressed(_:)), for: .touchUpInside)
        return but
        }()
    
    lazy var logoutButton:UIButton = {[unowned self] in
        let but = UIButton(frame:.zero)
        but.setAttributedTitle("Logout".attributing([.textColor(.white),.font(.systemFont(ofSize: 16, weight: .regular)), .alignment(.left)]), for: .normal)
        but.contentMode = .scaleAspectFit
        but.titleLabel?.textAlignment = .left
        but.addTarget(self, action: #selector(tabPressed(_:)), for: .touchUpInside)
        return but
        }()
    
    
    
    
    @objc func tabPressed(_ sender:UIButton){
        toggleSideBar()
        if sender == accountButton{
            actionForAccountButton?()
        }else if sender == deletebutton{
            actionForDeleteButton?()
        }else if sender == detailButton{
            actionForDetailButton?()
        }else{
            actionForLogoutButton?()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    func initialize(){
        backgroundColor = .slate
        addSubview(accountButton)
        addSubview(deletebutton)
        addSubview(detailButton)
        addSubview(logoutButton)
        dropShadow(5, color: .black, 0.8, CGSize(width: 0, height: 4))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        accountButton.layout{
            $0.leading == leadingAnchor + horizontalInsetBy(0.5)
            $0.top == topAnchor + verticalInsetBy(2)
            $0.height |=| 30
             $0.width |=| "Account".width(withConstrainedHeight: 30, font: .systemFont(ofSize: 16))
        }
        
        deletebutton.layout{
            $0.leading == leadingAnchor + horizontalInsetBy(0.5)
            $0.top == accountButton.bottomAnchor + verticalInset
            $0.height |=| 30
            $0.width |=| "Delete Photos".width(withConstrainedHeight: 30, font: .systemFont(ofSize: 16))
        }
        
        detailButton.layout{
            $0.leading == leadingAnchor + horizontalInsetBy(0.5)
            $0.top == deletebutton.bottomAnchor + verticalInset
            $0.height |=| 30
            $0.width |=| "Users".width(withConstrainedHeight: 30, font: .systemFont(ofSize: 16))
        }
        
        logoutButton.layout{
            $0.leading == leadingAnchor + horizontalInsetBy(0.5)
            $0.bottom == bottomAnchor - verticalInset
            $0.height |=| 30
            $0.width |=| "Log Out".width(withConstrainedHeight: 30, font: .systemFont(ofSize: 16))
        }
    }
    
    func toggleSideBar(){
        if isShowing{
            isShowing = false
            UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut, animations: {
                self.frame.origin.x = UIScreen.width + self.horizontalInsetBy(4)
            }, completion: nil)
        }else{
           isShowing = true
            UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut, animations: {
                self.frame.origin.x = UIScreen.width * 0.6
            }, completion: nil)
        }
    }
    
}
