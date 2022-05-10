//
//  UIScrollView + Extension.swift
//  Chat
//
//  Created by Олександр Швидкий on 07.05.2022.
//

import UIKit

extension UIScrollView {
    var isAtBotton: Bool {
        return contentOffset.y >= certicalOffsetForBottom
    }
    
    var certicalOffsetForBottom: CGFloat {
        let scrollViehheight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViehheight
        return scrollViewBottomOffset
    }
}
