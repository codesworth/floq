//
//  Persistence.swift
//  Floq
//
//  Created by Shadrach Mensah on 15/08/2019.
//  Copyright © 2019 Arun Nagarajan. All rights reserved.
//

import CoreData
import FirebaseFirestore.FIRDocumentSnapshot


public struct CMTSubscription{
    
    private let stack = CoreDataStack.stack
    
    func save(_ snap:DocumentSnapshot){
        var cliqsub:CMTCliqSubscription?
        let id = snap.documentID
        cliqsub = fetchCliqSub(id)
        if (cliqsub != nil){
            cliqsub!.count = snap.getInt64(.count)
            if let photos = snap.data(){
                for (key, val) in photos{
                    let photo = fetchPhotoSub(id: key)
                    if photo != nil{
                        let ts = (val as! [String:Any])[Fields.ts.rawValue] as! Int64
                        photo?.canBroadcast = photo!.lastTimestamp < ts
                        photo?.lastTimestamp = ts
                        photo?.count = (val as! [String:Any])[Fields.ts.rawValue] as! Int64
                    }else{
                        let photo = CMTPhotoSubscription(context: stack.persistentContainer.viewContext)
                        photo.photoID = key
                        if let val = val as? [String:Any]{
                            photo.count = val[Fields.count.rawValue] as! Int64
                            photo.lastTimestamp = val[Fields.ts.rawValue] as! Int64
                            photo.canBroadcast = true
                        }
                        cliqsub?.addToPhotoSubscriptions(photo)
                    }
                }
            }
            
        }else{
            cliqsub  = CMTCliqSubscription(context: stack.persistentContainer.viewContext)
            cliqsub!.cliqID = snap.documentID
            cliqsub!.count = snap.getInt64(.count)
            
            if let photos = snap.data(){
                for (key, val) in photos{
                    if key == Fields.count.rawValue {continue}
                    let photo = CMTPhotoSubscription(context: stack.persistentContainer.viewContext)
                    photo.photoID = key
                    if let val = val as? [String:Any]{
                        photo.count = Int64(val[Fields.count.rawValue] as! Int)
                        photo.lastTimestamp = Int64(val[Fields.ts.rawValue] as! Int)
                        photo.canBroadcast = true
                    }
                    cliqsub!.addToPhotoSubscriptions(photo)
                }
            }
        }
        stack.saveContext()
        broadcast(id: snap.documentID)
    }
    
    func fetchCliqSub(_ id:String)->CMTCliqSubscription?{
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "\(CMTCliqSubscription.self)")
        let sortdesc = NSSortDescriptor(key:"cliqID", ascending: true)
        req.sortDescriptors = [sortdesc]
        let pred = NSPredicate(format: "%K = %@", "cliqID", id)
        req.predicate = pred
        
        do {
            let cliq = try stack.context.fetch(req) as? [CMTCliqSubscription]
            return cliq?.first
        } catch let err {
            print(err.localizedDescription)
            
        }
        return nil
    }
    
    

    
    func fetchPhotoSub(id:String)->CMTPhotoSubscription?{
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "\(CMTPhotoSubscription.self)")
        let sortdesc = NSSortDescriptor(key:"photoID" , ascending: true)
        req.sortDescriptors = [sortdesc]
        let pred = NSPredicate(format: "%K = %@", "photoID", id)
        req.predicate = pred
        
        do {
            let photo = try stack.context.fetch(req)
            if photo.isEmpty{
                return nil
            }else{
                return photo.first as? CMTPhotoSubscription
            }
        } catch let err {
            print(err.localizedDescription)
            
        }
        return nil
    }
    
    
    func broadcast(id:String){
       Subscription.main.post(suscription: .newHighlight, object: id)
    }
    
    func endHightlightFor(_ photo:String){
        guard let photo = fetchPhotoSub(id: photo) else {return}
        photo.canBroadcast = false
        stack.saveContext()
    }
    
}

/*
 
class CustomSnapshot:DocumentSnapshot{
    
    override func data() -> [String : Any]? {
        return [Fields.count.rawValue:10,
            "xxxxx":[
                "ts":124567345,
                "count":122
            ],
            "xyxxx":[
                "ts":234567,
                "count":23
            ]
        ]
        
    }
    
    override var documentID: String{
        return "Amama"
    }
    
    init(id:String){
        
    }
}
 */
