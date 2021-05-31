import Foundation


extension NSAttributedString{
    
    public func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.width)
    }
    
    public func height(withConstrainedWidth width: CGFloat) -> CGFloat {
           let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
           let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
           return ceil(boundingBox.height)
       }
    
    static func +(lhs:NSAttributedString, rhs:NSAttributedString)->NSAttributedString{
        let attr = NSMutableAttributedString(attributedString: lhs)
        attr.append(rhs)
        return attr
    }

}
