import Foundation
import UIKit

public protocol NibView: UIView {
    static func fromNib() -> Self
}

public class ViewWrapperCell<T: UIView>: UICollectionViewCell {
    public var view: T!

    override public init(frame: CGRect) {
        super.init(frame: frame)
        if let nibType = T.self as? NibView.Type {
            self.view = nibType.fromNib() as? T
        } else {
            self.view = T(frame: frame)
        }
        contentView.addSubview(view)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        view.pin(to: contentView)
    }
}

public class ViewWrapperTableViewCell<T: UIView>: UITableViewCell {
    public var view: T!

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if let nibType = T.self as? NibView.Type {
            self.view = nibType.fromNib() as? T
        } else {
            self.view = T(frame: frame)
        }
        contentView.addSubview(view)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        view.pin(to: contentView)
    }
}
