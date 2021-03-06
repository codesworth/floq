//
//  CommentEngine.swift
//  Floq
//
//  Created by Shadrach Mensah on 16/07/2019.
//  Copyright © 2019 Arun Nagarajan. All rights reserved.
//

import FirebaseFirestore


class CommentEngine:NSObject{
    
    
    typealias Comments = Array<Comment>
    typealias Completion = (_ error:Error?) -> ()
    
    private var _QUERY_LIMIT = 20
    private var _internalComments:Comments = []
    private var photoOrCliqId:String
    private var lastSnapshot:DocumentSnapshot?
    private var listener:ListenerRegistration?
    private var isMessageBoard = false
    
    
    private var messageBoard:CollectionReference{
        if isMessageBoard{
            return Firestore.database.collection(.messageBoard)
        }
        return Firestore.database.collection(.comment)
    }
    
    
    var exhausted = false
    
    init(photoOrCliq id:String,isMessageBoard:Bool) {
        photoOrCliqId = id
        self.isMessageBoard = isMessageBoard
        super.init()
        
    }
    
    func removeListener(){
        listener?.remove()
    }
    
    var comments:Comments{
        
        return _internalComments.sorted{$0.timestamp > $1.timestamp}
    }
    
    
    
    func watchForComments(completion:@escaping Completion){
        let query:Query
        let field = isMessageBoard ? Comment.Keys.cliqID.rawValue : Comment.Keys.photoID.rawValue
        if _internalComments.isEmpty{
            query = messageBoard.whereField(field, isEqualTo: photoOrCliqId).limit(to: _QUERY_LIMIT).order(by: Comment.Keys.timestamp.rawValue, descending: true)
        }else{
            guard let last = lastSnapshot else {return}
            query = messageBoard.whereField(field, isEqualTo: photoOrCliqId).order(by: Comment.Keys.timestamp.rawValue, descending: true).start(afterDocument: last).limit(to: _QUERY_LIMIT)
        }
        
        
        
        listener = query.addSnapshotListener { (querySnap, error) in
            guard let docs = querySnap?.documents else {return}
            self.lastSnapshot = docs.last
            if docs.count < self._QUERY_LIMIT {self.exhausted = true}
            docs.forEach{
                if ($0.get(Comment.Keys.timestamp.rawValue) == nil){return}
                let comment = Comment(snapshot: $0)
                if !self._internalComments.contains(comment){
                    self._internalComments.append(comment)
                }
            }
            completion(error)
        }
    }
    
    func postAComment(_ comment:Comment.Raw, completion:@escaping Completion){
        let batch = Firestore.database.batch()

        batch.setData(comment.data() as [String : Any], forDocument: messageBoard.document(), merge: true)
        batch.commit() { err in
            completion(err)
        }
        notifierTransaction(comment: comment)
    }
    
    func notifierTransaction(comment:Comment.Raw){
        let db =  Firestore.database
        let notifierRef = db.collection(.commentNotifier).document(comment.cliqID)
        db.runTransaction({ (transaction, errorP) -> Any? in
            let doc:DocumentSnapshot
            do{
                doc = try transaction.getDocument(notifierRef)
            }catch let err as NSError{
                print("Erro occucrred in transaction: \(err.localizedDescription)")
                errorP?.pointee = err
                return nil
            }
            if doc.exists{
                guard var data = doc.data() else {return nil}
                let commentCount = doc.getInt(.cliqComments)
                var photoMap = doc.getDictionary(comment.photoID)
                let count = photoMap[Fields.count.rawValue] as? Int ?? 0
                photoMap[Fields.count.rawValue] = count + 1
                photoMap[Fields.lastUpdated.rawValue] = FieldValue.serverTimestamp()
                photoMap[Fields.userUID.rawValue] = comment.commentorID
                data[Fields.cliqComments.rawValue] = commentCount + 1
                data[Fields.lastUpdated.rawValue] = FieldValue.serverTimestamp()
                data[comment.photoID] = photoMap
                transaction.updateData(data, forDocument: notifierRef)
            }else{
                let photoMap = [Fields.count.rawValue: 1,
                                Fields.lastUpdated.rawValue : FieldValue.serverTimestamp(),
                                Fields.userUID.rawValue : comment.commentorID] as [String : Any]
                                let data = [Fields.cliqComments.rawValue : 1,
                                            Fields.lastUpdated.rawValue : FieldValue.serverTimestamp(),
                                            comment.photoID : photoMap] as [String : Any]
                transaction.setData(data, forDocument: notifierRef, merge: true)
            }
            return nil
        }) { (_, err) in
            if let err = err {
                print("Transactional Error V2: \(err.localizedDescription)")
            }else{
                print("Transaction Succesful")
            }
        }
    }
    
    deinit {
        listener?.remove()
    }
    
    
    
}
