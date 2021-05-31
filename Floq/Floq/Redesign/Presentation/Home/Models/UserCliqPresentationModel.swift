import Foundation


struct UserCliqPresentationModel {
    let id: String
    let cliqTitle: String
    let followers: Int
    let messageCount: Int
    let imageReference: String
    let isLive: Bool
    let timestamp: Date
}

extension UserCliqPresentationModel: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension UserCliqPresentationModel: CliqDisplayDiffable {}

extension UserCliqPresentationModel : Comparable {
    static func < (lhs: UserCliqPresentationModel, rhs: UserCliqPresentationModel) -> Bool {
        lhs.timestamp < rhs.timestamp
    }
    
    
}
