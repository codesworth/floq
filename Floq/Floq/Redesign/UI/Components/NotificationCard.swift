import Foundation

private enum Constants {
    static let cornerRadius = CGFloat(8)
    static let numberLabelFontSize = CGFloat(36)
    static let notificationLabelFontSize = CGFloat(24)
    static let width = (UIScreen.width - CardStyleConstants.cardLeftMargin * 3) / 2
    static let height: CGFloat = 206
}

class NotificationCard: UIView, Insetable {
    
    private let background = UIImageView()
    private var numberLabel: UILabel!
    private var notificationLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Implemented")
    }
    
    func setup(with model: UIModel){
        let count = "\(model.notifications)"
        numberLabel.text = count
        let notificationText = (model.notifications == 1 ? "notification_singular" : "notification_plural").localize()
        notificationLabel.text = notificationText
    }
}


extension NotificationCard {
    private func initializeView(){
        background.dropCorner(Constants.cornerRadius)
        background.image = UIImage(named: "notification_card")!
        background.contentMode = .scaleAspectFill
        background.clipsToBounds = true
        
        numberLabel = .makeLabel(font: .systemFont(ofSize: Constants.numberLabelFontSize, weight: .semibold), textColor: .white, numberOfLines: 1)
        notificationLabel = .makeLabel(font: .systemFont(ofSize: Constants.notificationLabelFontSize, weight: .semibold), textColor: .white)
        addSubview(background)
        addSubview(numberLabel)
        addSubview(notificationLabel)
        
    }
    
    private func addConstraints(){
        layout{
            $0.width |=| Constants.width
            $0.height |=| Constants.height
        }
        background.pin(to: self)
        numberLabel.layout{
            $0.leading == leadingAnchor + horizontalInset
            $0.top == topAnchor + verticalInset
            //$0.trailing == trailingAnchor - horizontalInset
        }
        notificationLabel.layout{
            $0.leading == leadingAnchor + horizontalInset
            $0.top == numberLabel.bottomAnchor + halvedVerticalInset
            //$0.trailing == trailingAnchor - horizontalInset
        }
    }
}

extension NotificationCard {
    struct UIModel {
        let notifications: Int
    }
}
