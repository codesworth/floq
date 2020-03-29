//
//  MessageBoardView.swift
//  Floq
//
//  Created by OZE-Shadrach on 3/28/20.
//  Copyright © 2020 Arun Nagarajan. All rights reserved.
//

import UIKit


class MessageBoardView:UIView,Insetable{
    
    
    lazy var tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.separatorColor = .gray
        table.separatorStyle = .singleLine
        table.backgroundColor = .white
        table.register(UINib(nibName: CommentCell.Identifier, bundle: nil), forCellReuseIdentifier: CommentCell.Identifier)
        table.register(UINib(nibName: CommentAlternateCell.Identifier, bundle: nil), forCellReuseIdentifier: CommentAlternateCell.Identifier)
        return table
    }()
    
    
    
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
           addSubview(tableView)
       }
       
}
