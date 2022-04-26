//
//  StackView + Extension.swift
//  Chat
//
//  Created by Олександр Швидкий on 27.04.2022.
//

import UIKit

extension UIStackView  {
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
    }
}
