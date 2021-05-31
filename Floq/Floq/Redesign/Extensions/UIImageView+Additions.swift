import UIKit


extension UIImageView {
    func setup(
        with image: UIImage?,
        contentMode: UIView.ContentMode = .scaleAspectFit,
        clipsToBounds: Bool = true,
        cornerRadius: CGFloat = .zero
    ) {
        self.contentMode = contentMode
        self.image = image
        self.clipsToBounds = clipsToBounds
        dropCorner(cornerRadius)
    }
    
    class func setup(
        with image: UIImage?,
        contentMode: UIView.ContentMode = .scaleAspectFit,
        clipsToBounds: Bool = true,
        cornerRadius: CGFloat
    ) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = contentMode
        imageView.image = image
        imageView.clipsToBounds = clipsToBounds
        imageView.dropCorner(cornerRadius)
        return imageView
    }
}
