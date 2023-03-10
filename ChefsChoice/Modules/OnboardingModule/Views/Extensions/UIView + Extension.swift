import UIKit

extension UIView {
    func addSubviewWithoutAutoresizingMask(_ view: UIView) {
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
}
