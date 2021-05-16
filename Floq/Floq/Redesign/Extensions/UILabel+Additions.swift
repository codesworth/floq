import Foundation
import UIKit

public extension UILabel {
    class func makeLabel(
        font: UIFont,
        textColor: UIColor,
        alignment: NSTextAlignment = .natural,
        numberOfLines: Int = .zero,
        lineBreakMode: NSLineBreakMode = .byCharWrapping,
        adjustsFontSizeToFitWidth: Bool = false
    ) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = textColor
        label.textAlignment = alignment
        label.numberOfLines = numberOfLines
        label.lineBreakMode = lineBreakMode
        label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        return label
    }
}
