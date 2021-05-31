import Foundation
import Combine
import FirebaseFirestore

class UserDataRepository {
    
    @Published var user:FLUser?
    
    
    private var store:Firestore{
        return Firestore.database
    }
    
    init() {
        synchronizeSelf()
    }
    
    private var userRef: CollectionReference{
        
        return store.collection(References.users.rawValue)
    }
    
    private func synchronizeSelf(){
        userRef.document(UserDefaults.uid).addSnapshotListener { [ weak self ] (doc, err) in
            guard let self = self, let snap = doc, let _ = doc?.data() else {return}
            let user = FLUser(snap: snap)
            self.user = user
        }
    }
}
