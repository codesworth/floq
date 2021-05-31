import UIKit
import Combine

private enum Constants{
    static let liveCardSize = CGSize(width: UIScreen.width - 16, height: 206)
    static let cliqCardSize = CGSize(width: (UIScreen.width - 32) / 2, height: 176)
    static let cardSpacing = CGFloat(16)
}

class UserCliqViewController: UIViewController, Insetable {
    
    private var cancellables = Set<AnyCancellable>()
    
    private var collectionView: UICollectionView!
    private var emptyView = EmptyUserCliqView()
    private var datasource: UserCliqDisplayDataSource<UserCliqPresentationModel>!
    private var currentSnapshot: NSDiffableDataSourceSnapshot<Int,UserCliqPresentationModel> = .init()
    private let mapper = UserCliqModelMaapper()
    private var viewModel: UserCliqViewModelProtocol
    
    
    init(with viewModel: UserCliqViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        addConstraints()
        setupCollectionView()
        setupDataSource()
        //bind()
        //update(models: viewModel.userCliqs.value)
        title = "my_cliqs".localize()
    }
    
    func setupCollectionView(){
        collectionView.registerForReuse(ViewWrapperCell<HorizontalCliqCardView>.self)
        collectionView.registerForReuse(ViewWrapperCell<UserCliqCard>.self)
        collectionView.delegate = self
    }
    
    private func setupDataSource(){
        datasource = .init(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, model in
            return self?.cellFor(model: model, collectionView: collectionView, indexPath: indexPath)
        })
        
    }
    
    private func cellFor(model: UserCliqPresentationModel, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        if model.isLive {
            let cell:ViewWrapperCell<HorizontalCliqCardView> = collectionView.dequeueReusableCell(for: indexPath)
            cell.view.setup(with: mapper.map(model: model))
            return cell
        }else{
            let cell:ViewWrapperCell<UserCliqCard> = collectionView.dequeueReusableCell(for: indexPath)
            cell.view.setup(with: mapper.map(model: model))
            return cell
        }
    }
    
    private func bind(){
        viewModel.userCliqs.sink { [ weak self ] models in
            self?.update(models: models)
        }.store(in: &cancellables)
    }
    
    private func update(models: [UserCliqPresentationModel]){
        currentSnapshot = NSDiffableDataSourceSnapshot<Int,UserCliqPresentationModel>()
        currentSnapshot.appendSections([.zero])
        currentSnapshot.appendItems(models, toSection: .zero)
        datasource.apply(currentSnapshot)
    }
}

extension UserCliqViewController {
    private func initializeView(){
        view.backgroundColor = .black
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = Constants.cardSpacing
        layout.minimumLineSpacing = Constants.cardSpacing
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.allowsMultipleSelection = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        
        view.addSubview(collectionView)
        view.addSubview(emptyView)
        emptyView.isHidden = false
    }
    
    func addConstraints(){
        collectionView.pin(to: view, insets: .init(top: verticalInset, left: halvedHorizontalInset, bottom: .zero, right: halvedHorizontalInset))
        emptyView.pin(to: view, insets: .init(top: verticalInset, left: halvedHorizontalInset, bottom: .zero, right: halvedHorizontalInset))
    }
}


extension UserCliqViewController: UICollectionViewDelegate {
    
}

extension UserCliqViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = viewModel.userCliqs.value[indexPath.row]
        return model.isLive ? Constants.liveCardSize : Constants.cliqCardSize
    }
}
