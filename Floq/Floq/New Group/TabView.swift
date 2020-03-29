//
//  TabView.swift
//  Floq
//
//  Created by Shadrach Mensah on 27/03/2020.
//  Copyright © 2020 Arun Nagarajan. All rights reserved.
//

import UIKit


class TabView:UIView, Insetable{
    
    var actionForCommentIcon:CompletionHandlers.simpleBlock?
    var actionForHomeIcon:CompletionHandlers.simpleBlock?
    var actionForImageIcon:CompletionHandlers.simpleBlock?
    
    lazy var commentTab:UIButton = {[unowned self] in
        let but = UIButton(frame:.zero)
        but.setImage(#imageLiteral(resourceName: "tabcomment"), for: .normal)
        but.contentMode = .scaleAspectFit
        but.addTarget(self, action: #selector(tabPressed(_:)), for: .touchUpInside)
        return but
    }()
    
    lazy var homeTab:UIButton = {[unowned self] in
       let but = UIButton(frame:.zero)
       but.setImage(#imageLiteral(resourceName: "icon_app_rounded"), for: .normal)
        but.contentMode = .scaleAspectFit
        but.addTarget(self, action: #selector(tabPressed(_:)), for: .touchUpInside)
       return but
    }()
    
    lazy var imageActionTab:UIButton = {[unowned self] in
       let but = UIButton(frame:.zero)
       but.setImage(#imageLiteral(resourceName: "tabCamera"), for: .normal)
        but.contentMode = .scaleAspectFit
        but.addTarget(self, action: #selector(tabPressed(_:)), for: .touchUpInside)
       return but
   }()
    
    
    
    
    @objc func tabPressed(_ sender:UIButton){
        if sender == commentTab{
            actionForCommentIcon?()
        }else if sender == homeTab{
            actionForHomeIcon?()
        }else if sender == imageActionTab{
            actionForImageIcon?()
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
        backgroundColor = .charcoal
        addSubview(commentTab)
        addSubview(homeTab)
        addSubview(imageActionTab)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        commentTab.layout{
            $0.top == topAnchor + verticalInsetBy(0.5)
            $0.leading == leadingAnchor + horizontalInsetBy(2)
            $0.height |=| 40
            $0.width |=| 40
        }
        
        homeTab.layout{
            $0.top == topAnchor + verticalInsetBy(0.5)
            $0.centerX == centerXAnchor
            $0.height |=| 40
            $0.width |=| 40
        }
        
        imageActionTab.layout{
            $0.top == topAnchor + verticalInsetBy(0.5)
            $0.trailing == trailingAnchor - horizontalInsetBy(2)
            $0.height |=| 40
            $0.width |=| 40
        }
    }
}
