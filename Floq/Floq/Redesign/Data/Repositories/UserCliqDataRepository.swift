import Foundation
import FirebaseFirestore
import FirebaseStorage


private enum Constants {
    static let cliqLimit = 20
}


class UserCliqDataRepository {
    
    private let uid: String
    private var lastSnapshot: DocumentSnapshot?
    @Published var userCliqs: Set<CliqDataModel> = []
    @Published var latastCliq: CliqDataModel?
    @Published var liveCliqs: Set<CliqDataModel> = []
    
    init(uid: String) {
        self.uid = uid
        queryForMyCliqs()
    }
    
    private var storage:Storage{
        return Storage.storage()
    }
    
    private var geofire:GeoFirestore{
        return GeoFirestore(collectionRef: Firestore.database.collection(References.flocations.rawValue))
    }
    
    private var userRef:CollectionReference{
        return Firestore.database.collection(.users)
    }
    

    
    private var floqRef:CollectionReference{
        return Firestore.database.collection(References.floqs.rawValue)
    }
    
    
    private func queryForMyCliqs(){
        var query:Query
        if userCliqs.isEmpty{
            query = floqRef.whereField(Fields.followers.rawValue, arrayContains: uid).limit(to: Constants.cliqLimit).order(by: Fields.timestamp.rawValue, descending: true)
        }else{
            guard let last = lastSnapshot else {return}
            query = floqRef.whereField(Fields.followers.rawValue, arrayContains: uid).order(by: Fields.timestamp.rawValue, descending: true).start(atDocument: last).limit(to: Constants.cliqLimit)
        }
        query.addSnapshotListener { [ weak self ] (querySnap, err) in
            guard let self = self else { return }
            if let query = querySnap{
                self.lastSnapshot = query.documents.last
                let cliqs = query.documentChanges.map(\.document).map(CliqDataModel.init)
                self.update(cliqs: cliqs)
                
            }
        }
    }
    
    private func update(cliqs: [CliqDataModel]){
        var updatableCliqs = userCliqs
        cliqs.forEach { updatableCliqs.update(with: $0) }
        userCliqs = updatableCliqs
        latastCliq = updatableCliqs.sorted().last
        liveCliqs = updatableCliqs.filter(\.isActive)
        Logger.debug(latastCliq!.fileID)
    }
}
