import UIKit

public extension UIStackView {
    class func stack(
        views: [UIView],
        axis: NSLayoutConstraint.Axis,
        alignment: Alignment,
        distribution: Distribution,
        spacing: CGFloat
    ) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.alignment = alignment
        stack.distribution = distribution
        stack.axis = axis
        stack.spacing = spacing

        return stack
    }
}
