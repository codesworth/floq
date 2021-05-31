import UIKit

protocol CliqDisplayDiffable: Hashable {
    var id: String { get }
}

extension CliqDisplayDiffable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class UserCliqDisplayDataSource<T : Hashable>: UICollectionViewDiffableDataSource<Int,T> {
    
}
