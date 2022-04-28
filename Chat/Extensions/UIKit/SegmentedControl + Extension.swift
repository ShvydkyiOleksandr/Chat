//
//  SegmentedControl + Extension.swift
//  Chat
//
//  Created by Олександр Швидкий on 28.04.2022.
//

import UIKit

extension UISegmentedControl {
    convenience init(firsrt: String, second: String) {
        self.init()
        
        self.insertSegment(withTitle: firsrt, at: 0, animated: true)
        self.insertSegment(withTitle: second, at: 1, animated: true)
        self.selectedSegmentIndex = 0
    }
}
