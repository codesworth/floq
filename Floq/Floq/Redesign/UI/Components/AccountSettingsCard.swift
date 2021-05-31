import UIKit


private enum Constants {
    static let cornerRadius = CGFloat(8)
    static let titleFontSize = CGFloat(18)
    static let avatarHeight: CGFloat = 40
    static let avatarWidth: CGFloat = 40
    static let width = (UIScreen.width - CardStyleConstants.cardLeftMargin * 3) / 2
    static let height: CGFloat = 206
}

class AccountSettingsCard: UIView, Insetable {
    
    private let background = UIImageView()
    private var label: UILabel!
    private let avatarImageView = AvatarImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Implemented")
    }
    
    func setup(with model: UIModel){
        avatarImageView.setAvatar(uid: model.accountUid)
        label.text = "account_settings".localize()
    }
}


extension AccountSettingsCard {
    private func initializeView(){
        background.dropCorner(Constants.cornerRadius)
        background.image = UIImage(named: "account_settings")!
        background.contentMode = .scaleAspectFill
        background.clipsToBounds = true
        
        label = .makeLabel(font: .systemFont(ofSize: Constants.titleFontSize, weight: .semibold), textColor: .white)
        
        addSubview(background)
        addSubview(label)
        addSubview(avatarImageView)
    }
    
    private func addConstraints(){
        layout{
            $0.width |=| Constants.width
            $0.height |=| Constants.height
        }
        background.pin(to: self)
        avatarImageView.layout{
            $0.leading == leadingAnchor + horizontalInset
            $0.top == topAnchor + verticalInset
            $0.width |=| Constants.avatarWidth
            $0.height |=| Constants.avatarHeight
        }
        
        label.layout{
            $0.leading == leadingAnchor + horizontalInset
            //$0.trailing == trailingAnchor - horizontalInset
            $0.top == avatarImageView.bottomAnchor + halvedVerticalInset
        }
    }
}


extension AccountSettingsCard {
    struct UIModel {
        let accountUid: String
    }
}

