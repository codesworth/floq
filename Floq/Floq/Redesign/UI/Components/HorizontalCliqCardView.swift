import UIKit
import FirebaseStorage

private enum Constants {
    static let titleFontSize = CGFloat(30)
    static let regularFontSize = CGFloat(18)
    static let width = UIScreen.width - (CardStyleConstants.cardLeftMargin + CardStyleConstants.cardRightMargin)
    static let height = CGFloat(207)
}

class HorizontalCliqCardView: UIView, Insetable {
    
    private let imageView = UIImageView()
    private var titleLabel: UILabel!
    private var cliqsLabel: UILabel!
    private var lineDashShapeLayer: CAShapeLayer?
    private var tapAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initiliazeViews()
        addConstraint()
        addTapListener()
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
        cliqsLabel.textColor = .white
        cliqsLabel.text = model.cliqsText
        guard let file = model.imageReference else { return }
        imageView.sd_setImage(with: Storage.floqPhotos.child(file))
        tapAction = model.onCardSelected
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
    
    func addTapListener(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
    }
    
    @objc private func cardTapped(){
        tapAction?()
    }
}


extension HorizontalCliqCardView {
    private func initiliazeViews(){
        backgroundColor = .charcoal
        addCardStyle()
        clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        titleLabel = .makeLabel(font: .systemFont(ofSize: Constants.titleFontSize, weight: .bold), textColor: .white)
        titleLabel.text = "my_cliqs".localize()
        cliqsLabel = .makeLabel(font: .systemFont(ofSize: 16, weight: .regular), textColor: .white)
        
        addSubview(imageView)
        addOverlayCardStyle()
        addSubview(titleLabel)
        addSubview(cliqsLabel)
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
        
    }
}


extension HorizontalCliqCardView {
    struct UIModel {
        let title: String
        let cliqsText: String
        let imageReference: String?
        var showEmpty: Bool = false
        var onCardSelected: (() -> Void)? = nil
    }
}
