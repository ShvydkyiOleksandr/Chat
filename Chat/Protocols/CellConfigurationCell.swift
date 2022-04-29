//
//  CellConfigurationCell.swift
//  Chat
//
//  Created by Олександр Швидкий on 30.04.2022.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func configure(with value: MChat)
}
