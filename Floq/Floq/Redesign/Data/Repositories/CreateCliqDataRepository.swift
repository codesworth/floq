import Foundation
import FirebaseFirestore
import FirebaseStorage

class CreateCliqDataRepository {
    
    private var uid: String
    
    init(uid: String) {
        self.uid = uid
    }
    
    private var store:Firestore{
        return Firestore.database
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
    
    
    func create(cliq: CreateCliqDataModel, onFinish:@escaping (Result<Void,AppError>) -> ()){
        
        userRef.document(uid).getDocument { [weak self] (snapshotq, err) in
            guard let self = self, let snap = snapshotq else{
                onFinish(.failure(.init(errorMessage: err != nil ? err!.localizedDescription : "Failed to create new cliq")))
                return
            }
            let count = snap.getInt(.cliqCount)
            let batch = self.store.batch()
            let tpath = Int(Date.timeIntervalSinceReferenceDate * 1000)
            let filePath = "\(cliq.name) - \(tpath)"
            let geofire = GeoFirestore(collectionRef: self.geofireRef)
            let uid = UserDefaults.uid
            let newMetadata = StorageMetadata()
            let userName =  snap.getString(.username)
            
            newMetadata.customMetadata = [
                Fields.fileID.rawValue : filePath,
                Fields.username.rawValue : userName,
                Fields.userUID.rawValue: self.uid,
                Fields.cliqname.rawValue : cliq.name
                
            ]
            
            Storage.floqPhotos.child(filePath)
                .putData(cliq.imageData, metadata: newMetadata, completion: { (metadata, error) in
                    if let error = error {
                        onFinish(.failure(.init(errorMessage: "Error uploading: \(error)")))
                        print("Error uploading: \(error)")
                        return
                    }
                    let coordinate = GeoPoint(coordinate: cliq.location)
                    var docData: [String: Any] = [
                        "timestamp" : FieldValue.serverTimestamp(),
                        Fields.followers.rawValue: [UserDefaults.uid],
                        Fields.coordinate.rawValue:coordinate
                    ]
                    docData.merge(newMetadata.customMetadata!, uniquingKeysWith: { (_, new) in new })
                    print(docData, filePath)
                    let cliqID = self.floqRef.document(filePath)
                    batch.setData(docData, forDocument: cliqID, merge: true)
                    
                    
                    let addata = [Fields.cliqCount.rawValue: count + 1]
                    batch.setData(addata, forDocument: self.userRef.document(uid), merge: true)
                    docData.removeValue(forKey: Fields.cliqname.rawValue)
                    docData.removeValue(forKey:  Fields.followers.rawValue)
                    docData.removeValue(forKey:  Fields.userEmail.rawValue)
                    docData.removeValue(forKey: Fields.coordinate.rawValue)
                    docData.updateValue(false, forKey: Fields.flagged.rawValue)
                    docData.updateValue([], forKey: Fields.flaggers.rawValue)
                    docData.updateValue(cliqID.documentID, forKey: Fields.cliqID.rawValue)
                    batch.setData(docData, forDocument:self.store.collection(References.photos.rawValue).document("\(tpath)") , merge: true)
                    batch.commit(completion: { (err) in
                        if err != nil {
                            onFinish(.failure(.init(errorMessage: "Error writing document data")))
                            
                        } else {
                            geofire.setLocation(location: cliq.location, forDocumentWithID: filePath, addTimeStamp: true, completion: nil)
                            onFinish(.success(()))
                        }
                    })
                    
                })
        }
    }
}
