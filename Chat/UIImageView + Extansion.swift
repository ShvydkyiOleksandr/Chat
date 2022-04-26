//
//  UIImageView + Extansion.swift
//  Chat
//
//  Created by Олександр Швидкий on 26.04.2022.
//

import UIKit

extension UIImageView {
    convenience init(image: UIImage, contentMode: UIView.ContentMode) {
        self.init()
        
        self.image = image
        self.contentMode = contentMode
    }
}
