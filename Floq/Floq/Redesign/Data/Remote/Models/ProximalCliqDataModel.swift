//
//  ProximalCliqDataModel.swift
//  Floq
//
//  Created by ES-Shadrach on 15/05/2021.
//  Copyright © 2021 Arun Nagarajan. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct ProximalCliqDataModel {
    public private (set) var id:String
    public private (set) var fileID:String
    public private (set) var name:String
    public private (set) var creatorUid:String
    public private (set) var creatorName:String
    public private (set) var followers: Set<String>
    public private (set) var flaggers:[String] = []
    public private (set) var isActive:Bool
    public private (set) var timestamp:Date
    public var shouldFlagCover:Bool = false
    public private(set) var location:CLLocation?
    public var joined:Bool
    
    init(snapshot:DocumentSnapshot) {
        
        id = snapshot.documentID
        self.name = snapshot.getString(.cliqname)
        creatorUid = snapshot.getString(.userUID)
        timestamp = snapshot.getDate(.timestamp)
        creatorName = snapshot.getString(.username)
        fileID = snapshot.getString(.fileID)
        flaggers = snapshot.getArray(.flaggers) as? [String] ?? []
        followers = []
        if let data = snapshot.get(Fields.followers.rawValue) as? [String]{
            self.followers = Set<String>(data)
        }
    
        if followers.isEmpty{
            self.followers.insert(creatorUid)
        }
        isActive = timestamp.nextDay > Date()
        joined = followers.contains(UserDefaults.uid)
        location = snapshot.getLocation(.coordinate)
        //getPhotoItem(id: id)
        
    }
}
