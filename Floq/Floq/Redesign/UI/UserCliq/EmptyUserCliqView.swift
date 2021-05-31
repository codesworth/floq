import UIKit

private enum Constants {
    static let titleFontSize: CGFloat = 28
    static let detailFontSize: CGFloat = 24
}

class EmptyUserCliqView: UIView, Insetable {
    
    private let imageView = UIImageView()
    
    private var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension EmptyUserCliqView {
    private func initializeView(){
        backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "empty_cliqs")
        
        titleLabel.numberOfLines = .zero
        titleLabel.attributedText = "my_cliqs".localize().attributing([.font(.systemFont(ofSize: Constants.titleFontSize, weight: .semibold)), .textColor(.pear)]) + "\n\n".attributing([]) + "empty_cliq_info".localize().attributing([.font(.systemFont(ofSize: Constants.detailFontSize, weight: .semibold)), .textColor(.white)])
        
        addSubview(imageView)
        addSubview(titleLabel)
    }
    
    func addConstraints(){
        imageView.pin(to: self)
        titleLabel.layout{
            $0.leading == leadingAnchor + horizontalInset
            $0.trailing == trailingAnchor - horizontalInset
            $0.top == topAnchor + doubleVerticalInset
        }
    }
}
