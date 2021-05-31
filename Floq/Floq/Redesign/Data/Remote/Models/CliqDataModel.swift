//
//  CliqDataModel.swift
//  Floq
//
//  Created by ES-Shadrach on 22/05/2021.
//  Copyright © 2021 Arun Nagarajan. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct CliqDataModel{
    
    enum Max:Int {
        case followers = 30
        case photos = 100
        
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id && lhs.creatorUid == rhs.creatorUid
    }

    
    func isMember(_ id:String? = nil)->Bool{
        let id = id ?? UserDefaults.uid
        return followers.contains(id)
    }
    
    
    public var followString:String{
        let count = followers.count
        return (count != 1) ? "\(count) followers" : "1 follower"
    }
    
    public var canFollow:Bool{
        return followers.count < Max.followers.rawValue
    }
    
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
        //item = PhotoItem(id:id, photoID: snapshot.getString(.fileID), user: snapshot.getString(.username), timestamp: timestamp,uid:creatorUid)
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
    
    func hasFlagged()->Bool{
        let id = UserDefaults.uid
        return flaggers.contains(id)
    }
    
}


extension CliqDataModel: Hashable, Equatable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


extension CliqDataModel: Comparable {
    static func < (lhs: CliqDataModel, rhs: CliqDataModel) -> Bool {
        lhs.timestamp < rhs.timestamp
    }
    
    
}
