import UIKit
import FirebaseStorage

private enum Constants {
    static let titleFontSize = CGFloat(16)
    static let messageCountFontSize = CGFloat(14)
    static let regularFontSize = CGFloat(18)
    static let width = (UIScreen.width - 48) / 2
    static let height = CGFloat(176)
    static let messageIconSize: CGSize = .init(width: 20, height: 20)
}

class UserCliqCard: UIView, Insetable {
    
    private let imageView = UIImageView()
    private var titleLabel: UILabel!
    private var cliqsLabel: UILabel!
    private var lineDashShapeLayer: CAShapeLayer?
    private let messageIcon = UIImageView()
    private var messgesCountLabel: UILabel!
    private var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initiliazeViews()
        addConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Implemented")
    }
    
    func setup(with model: UIModel){
        guard !model.showEmpty else {
            showEmptyState()
            return
        }
        titleLabel.text = model.title
        messgesCountLabel.text = "\(model.messages)"
        cliqsLabel.textColor = .white
        cliqsLabel.text = model.cliqsText
        guard let file = model.imageReference else { return }
        imageView.sd_setImage(with: Storage.floqPhotos.child(file))
    }
    
    private func showEmptyState(){
        cliqsLabel.textColor = .pear
        cliqsLabel.text = "home_empty_cliq".localize()
        let shapeBounds = CGRect(origin: .zero, size: .init(width: Constants.width, height: Constants.height))
        lineDashShapeLayer?.removeFromSuperlayer()
        lineDashShapeLayer = CAShapeLayer()
        lineDashShapeLayer?.lineWidth = 4
        lineDashShapeLayer?.strokeColor = UIColor.cloudyBlue.cgColor
        lineDashShapeLayer?.fillColor = nil
        lineDashShapeLayer?.lineDashPattern = [5,5]
        lineDashShapeLayer?.frame = shapeBounds
        lineDashShapeLayer?.path = UIBezierPath(roundedRect: shapeBounds, cornerRadius: 8).cgPath
        layer.addSublayer(lineDashShapeLayer!)
    }
}


extension UserCliqCard {
    private func initiliazeViews(){
        backgroundColor = .charcoal
        addCardStyle()
        clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        titleLabel = .makeLabel(font: .systemFont(ofSize: Constants.titleFontSize, weight: .semibold), textColor: .white)
        cliqsLabel = .makeLabel(font: .systemFont(ofSize: Constants.messageCountFontSize, weight: .medium), textColor: .white)
        messageIcon.contentMode = .scaleAspectFit
        messageIcon.image = UIImage(named: "ic_message_icon")
        messageIcon.frame.size = Constants.messageIconSize
        messgesCountLabel = .makeLabel(font: .systemFont(ofSize: Constants.messageCountFontSize, weight: .medium), textColor: .white)
        stackView = .stack(views: [messageIcon,messgesCountLabel], axis: .horizontal, alignment: .center, distribution: .fillProportionally, spacing: 8)
        
        addSubview(imageView)
        addOverlayCardStyle()
        addSubview(titleLabel)
        addSubview(cliqsLabel)
        addSubview(stackView)
    }
    
    private func addConstraint(){
        layout{
            $0.width |=| Constants.width
            $0.height |=| Constants.height
        }
        imageView.pin(to: self)
        titleLabel.layout{
            $0.leading == leadingAnchor + horizontalInset
            $0.top == topAnchor + verticalInset
        }
        
        cliqsLabel.layout{
            $0.leading == leadingAnchor + horizontalInset
            $0.bottom == bottomAnchor - verticalInset
        }
        stackView.layout{
            $0.leading == leadingAnchor + horizontalInset
            $0.bottom == cliqsLabel.topAnchor - verticalInset
            $0.trailing == trailingAnchor - horizontalInset
        }
        
    }
}


extension UserCliqCard {
    struct UIModel {
        let title: String
        let cliqsText: String
        let messages:Int
        let imageReference: String?
        var showEmpty: Bool = false
    }
}

