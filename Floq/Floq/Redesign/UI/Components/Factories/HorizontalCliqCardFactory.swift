import UIKit


class HorizontalCliqCardFactory: DefaultCardFactory<ViewWrapperCell<HorizontalCliqCardView>> {
    
    private let model: HorizontalCliqCardView.UIModel
    
    init(with model: HorizontalCliqCardView.UIModel){
        self.model = model
    }
    
    override func getCellInstance(_ collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ViewWrapperCell<HorizontalCliqCardView> = collectionView.dequeueReusableCell(for: indexPath)
        cell.view.setup(with: model)
        
        return cell
    }
}
