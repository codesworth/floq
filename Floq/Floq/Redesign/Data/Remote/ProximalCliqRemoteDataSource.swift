import Foundation
import FirebaseFirestore

class ProximalCliqRemoteDataSource {
    
    private let radius = 0.5
    private var query:GFSQuery?
    
    
    var onDocumentEntered: ((ProximalCliqDataModel) -> Void)?
    var onDocumentExit: ((String) -> Void)?
    
    
    private var geofire:GeoFirestore{
        return GeoFirestore(collectionRef: Firestore.database.collection(References.flocations.rawValue))
    }
    
    private var database: Firestore { .database }
    
    
    func listenForCliqsAt(geopoint:GeoPoint){
        query = geofire.query(withCenter: geopoint, radius: radius)
            let _ = query!.observe(.documentEntered) { (id, location) in
            if let id = id {
                let date = self.getTimeFromIdFormat(id: id)
                if date != nil{
                    if date!.nextDay < Date(){ return }
                }
                //self.nearbyIds.add(id)
                self.getNearbyDocument(id: id)
            }
        }
        
        let _ = query!.observe(.documentExited) { (id, location) in
            guard let id = id else{return}
            self.onDocumentExit?(id)
        }
        
    }
    
    
    private func getNearbyDocument(id:String){
        database.collection(References.floqs.rawValue)
            .document(id)
            .addSnapshotListener({ (snapshot, error) in
                if error == nil && snapshot != nil, snapshot!.exists {
                    let cliq = ProximalCliqDataModel(snapshot: snapshot!)
                    if cliq.isActive {
                        self.onDocumentEntered?(cliq)
                    }
                }else{
                    Logger.log(error)
                }
                
            })
        
    }
    

    
    
    func getTimeFromIdFormat(id:String)->Date?{
        
        let ns = id.replacingOccurrences(of: " ", with: "")
        let chset = ns.split(separator: "-")
        if chset.count == 2{
            if let ts = Int(chset.last!){
                return Date(timeIntervalSinceReferenceDate: TimeInterval((ts / 1000)))
            }
        }
        return nil
    }
    
}
