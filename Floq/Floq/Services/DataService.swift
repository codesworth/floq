//
//  DataService.swift
//  Floq
//
//  Created by Mensah Shadrach on 30/09/2018.
//  Copyright © 2018 Arun Nagarajan. All rights reserved.
//

import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Geofirestore
import CoreLocation
import SDWebImage



class DataService{
    
    private static let _main = DataService()
    
    
    static var main:DataService{
        
        return _main
        
    }
    
    public static var profileIDs:Set<String> = []
    
    private var store:Firestore{
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        return db
    }
    
    
    
    private var geofireRef:CollectionReference{
        return store.collection(References.flocations.rawValue)
    }
    
    private var floqRef:CollectionReference{
        return store.collection(References.floqs.rawValue)
    }
    

    private var userRef: CollectionReference{
        
        return store.collection(References.users.rawValue)
    }
    
    
    func setUser(user:FLUser, handler:@escaping CompletionHandlers.dataservice){
        let data = [Fields.username.rawValue: user.username, Fields.dateCreated.rawValue:Date(),Fields.profileImg.rawValue:user.profileImg?.absoluteString ?? "",Fields.cliqCount.rawValue:0] as [String:Any]
        userRef.document(user.uid).setData(data) { (err) in
            if let error = err {
                if let url = user.profileImg{
                    Storage.reference(.userProfilePhotos).child(user.uid).putFile(from: url)
                }
                handler(nil, error.localizedDescription)
            }else{
                handler(true, nil)
            }
        }
    }
    
    func isRegistered(uid:String,handler:@escaping (_ exists:Bool, _ username:String?)->()){
        userRef.document(uid).getDocument { (snap, err) in
            if let snap = snap{
                if snap.exists{
                    handler(true,snap.getString(.username))
                }else{
                   handler(false,nil)
                }
            }else{
               handler(false,nil)
            }
        }
    }
    
    
    func getAndStoreProfileImg(imgUrl:URL,uid:String){
        let downloader = SDWebImageDownloader.shared()
        downloader.downloadImage(with: imgUrl, options: [.lowPriority], progress: nil) { (imge, data, err, succ) in
            if let image = imge{
                print("Image Succesfully Saved from facebool")
                let ef = Storage.reference(.userProfilePhotos).child(uid)
                SDImageCache.shared().store(image, forKey: ef.fullPath, toDisk: true, completion: nil)
                ef.putData(image.pngData() ?? data!)
            }
        }
    }
    
    func cleanUp(uid:String){
        let rtepData:Aliases.dictionary = [Fields.username.rawValue:"Floq user",Fields.profileImg.rawValue:"placeholder",Fields.deleted.rawValue:true,Fields.dateDeleted.rawValue:Date()]
        userRef.document(uid).updateData(rtepData)
        Storage.reference(.userProfilePhotos).child(uid).delete { (err) in
            Logger.log(err)
        }
    }
    
    func joinCliq(cliq:FLCliqItem){
        let batch = store.batch()
        let uid = UserDefaults.uid
        (UIApplication.shared.delegate as! AppDelegate).appUser?.increaseCount()
        batch.updateData(["\(References.myCliqs.rawValue).\(cliq.id)":FieldValue.serverTimestamp()], forDocument: userRef.document(uid))
        let clef = floqRef.document(cliq.id)
        batch.updateData([Fields.followers.rawValue:FieldValue.arrayUnion([uid])], forDocument: clef)
        batch.commit { (err) in
            if let err = err{
                Logger.log(err)
            }else{
                
            }
        }
        let ref = userRef.document(uid)
        store.runTransaction({ (transaction, errorPointer) -> Any? in
            let doc:DocumentSnapshot
            do{
                try doc = transaction.getDocument(ref)
            }catch let err as NSError{
                errorPointer?.pointee = err
                return nil
            }
            
            guard let count = doc.get(Fields.cliqCount.rawValue) as? Int else{
                let error = NSError(domain: "Database", code: 404, userInfo: ["msg":"Field not found"])
                errorPointer?.pointee = error
                return nil
            }
            
            transaction.updateData([Fields.cliqCount.rawValue: count + 1], forDocument: ref)
            return nil
        }) { (_, err) in
            if let err = err{
                print("Transaction Failed with signature: \(err.localizedDescription)")
            }
        }
    }
    
    func removeCliq(_ key:String){
        let uid = UserDefaults.standard.string(forKey: Fields.uid.rawValue)!
        userRef.document(uid).collection(.myCliqs).document(key).delete()
        
    }
    
    func saveNewUserInstanceToken(token:String, complete:@escaping CompletionHandlers.storage){
        
        if let uid = UserDefaults.standard.string(forKey: Fields.uid.rawValue){
            store.collection(.tokenRefs).document(uid).setData([Fields.instanceToken.rawValue:token,Fields.dateCreated.rawValue:Date()], merge: true) { (err) in
                if let err = err {
                    complete(false,err.localizedDescription)
                }else{
                    complete(true,nil)
                }
            }
        }else{
            complete(false,"No uid")
        }
    }
    
    func getCliq(id:String, finish:@escaping (_ cliq:FLCliqItem?, _ errM:String?)->()){
        floqRef.document(id).getDocument { (snapshot, err) in
            if let snapshot = snapshot{
                if snapshot.exists{
                    let cliq = FLCliqItem(snapshot: snapshot)
                    finish(cliq,nil)
                }else{
                    finish(nil,"Cliq doesnt Exist")
                }
            }else{
                finish(nil,err?.localizedDescription)
            }
        }
    }
    
    
    func addNewCliq(image:UIImage, name:String,locaion:CLLocation, onFinish:@escaping CompletionHandlers.dataservice){
        
        userRef.document(UserDefaults.uid).getDocument { (snapshotq, err) in
            guard let snap = snapshotq else{
                onFinish(false,err?.localizedDescription ?? "")
                return
            }
            let count = snap.getInt(.cliqCount)
            let batch = self.store.batch()
            let tpath = Int(Date.timeIntervalSinceReferenceDate * 1000)
            let filePath = "\(name) - \(tpath)"
            let geofire = GeoFirestore(collectionRef: self.geofireRef)
            let uid = UserDefaults.uid
            let newMetadata = StorageMetadata()
            let userName =  snap.getString(.username)
            
            newMetadata.customMetadata = [
                Fields.fileID.rawValue : filePath,
                Fields.username.rawValue : userName,
                Fields.userUID.rawValue: Auth.auth().currentUser!.uid,
                Fields.cliqname.rawValue : name
                
            ]
            
            var data = Data()
            data = image.jpegData(compressionQuality: 1.0)!
            
            Storage.floqPhotos.child(filePath)
                .putData(data, metadata: newMetadata, completion: { (metadata, error) in
                    if let error = error {
                        onFinish(false,"Error uploading: \(error)")
                        print("Error uploading: \(error)")
                        return
                    }
                    let coordinate = GeoPoint(coordinate: locaion.coordinate)
                    var docData: [String: Any] = [
                        "timestamp" : FieldValue.serverTimestamp(),
                        Fields.followers.rawValue: [UserDefaults.uid],
                        Fields.coordinate.rawValue:coordinate
                    ]
                    docData.merge(newMetadata.customMetadata!, uniquingKeysWith: { (_, new) in new })
                    print(docData, filePath)
                    batch.setData(docData, forDocument: self.floqRef.document(filePath), merge: true)
                    
                    
                    let addata = [Fields.cliqCount.rawValue: count + 1]
                    batch.setData(addata, forDocument: self.userRef.document(uid), merge: true)
                    docData.removeValue(forKey: Fields.cliqname.rawValue)
                    docData.removeValue(forKey:  Fields.followers.rawValue)
                    docData.removeValue(forKey:  Fields.userEmail.rawValue)
                    docData.removeValue(forKey: Fields.coordinate.rawValue)
                    docData.updateValue(false, forKey: Fields.flagged.rawValue)
                    docData.updateValue([], forKey: Fields.flaggers.rawValue)
                    batch.setData(docData, forDocument:self.floqRef.document(filePath).collection(References.photos.rawValue).document("\(tpath)") , merge: true)
                    batch.commit(completion: { (err) in
                        if err != nil {
                            onFinish(false,"Error writing document data")
                            
                        } else {
                            //geofire.setLocation(location: locaion, forDocumentWithID: filePath)
                            geofire.setLocation(location: locaion, forDocumentWithID: filePath, addTimeStamp: true, completion: nil)
                            onFinish(true,nil)
                        }
                    })
                    
                })
        }
    }
    
    func blockUser(id:String,completion:@escaping CompletionHandlers.storage){
       let batch = store.batch()
        batch.setData([Fields.blockingList.rawValue:FieldValue.arrayUnion([id])], forDocument: userRef.document(UserDefaults.uid), merge:true)
        batch.setData([Fields.blockedList.rawValue:FieldValue.arrayUnion([id])], forDocument: userRef.document(id), merge: true)
        batch.commit(){ err in
            if let err = err{
                completion(false,err.localizedDescription)
            }else{
                completion(true,nil)
            }
        }
    }
    func unBlockUser(id:String,completion:@escaping CompletionHandlers.storage){
        let batch = store.batch()
        batch.setData([Fields.blockingList.rawValue:FieldValue.arrayRemove([id])], forDocument: userRef.document(UserDefaults.uid), merge:true)
        batch.setData([Fields.blockedList.rawValue:FieldValue.arrayRemove([id])], forDocument: userRef.document(id), merge: true)
        batch.commit(){ err in
            if let err = err{
                completion(false,err.localizedDescription)
            }else{
                completion(true,nil)
            }
        }
    }
    
    func synchronizeSelf(handler:@escaping CompletionHandlers.dataservice){
        userRef.document(UserDefaults.uid).addSnapshotListener { (doc, err) in
            guard let snap = doc, let _ = doc?.data() else {return}
            let user = FLUser(snap: snap)
            handler(user,nil)
        }
    }
    
    func listenForUpdates(handler:@escaping CompletionHandlers.dataservice){
        store.collection(.utils).document(References.updateDoc.rawValue).addSnapshotListener { (snapshot, err) in
            guard let snapshot = snapshot else {return}
            if let _ = snapshot.data(){
                let update = UpdateInfo(snap: snapshot)
                handler(update,nil)
            }
        }
    }
    

    
    func getUserWith(_ uid:String, handler:@escaping CompletionHandlers.dataservice){
        
        userRef.document(uid).getDocument { (snapshot, err) in
            if let snap = snapshot{
                let user = FLUser(snap: snap)
                handler(user,nil)
            }
        }
    }
    
//    func resizeImageForUpload(image:UIImage, error:inout NSError?)->ResultData{
//        let encodeRequirement = EncodeRequirement(format: .jpeg, mode: .lossy, quality: 80)
//        let transforms = Transformations()
//        transforms.resizeRequirement = ResizeRequirement(mode: .exactOrLarger, targetSize: CGSize(width: 2048, height: 2048))
//        
//        let options = EncodeOptions(encodeRequirement: encodeRequirement, transformations: transforms, metadata: nil, configuration: nil, outputPixelSpecificationRequirement: nil)
//        let data = Spectrum.shared.encodeImage(image, options: options, error: &error)
//        return data
//    }
    
    
}


/**
 FSPEncodeRequirement *encodeRequirement =
 [FSPEncodeRequirement encodeRequirementWithFormat:FSPEncodedImageFormat.jpeg
 mode:FSPEncodeRequirementModeLossy
 quality:80];
 
 FSPTransformations *transformations = [FSPTransformations new];
 transformations.resizeRequirement =
 [[FSPResizeRequirement alloc] initWithMode:FSPResizeRequirementModeExactOrSmaller
 targetSize:CGSizeMake(2048, 2048)];
 
 FSPEncodeOptions *options =
 [FSPEncodeOptions encodeOptionsWithEncodeRequirement:encodeRequirement
 transformations:transformations
 metadata:nil
 configuration:nil
 outputPixelSpecificationRequirement:nil];
 
 NSError *error;
 FSPResultData *result = [FSPSpectrum.sharedInstance encodeImage:image options:options error:&error];
 */
