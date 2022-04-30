//
//  UIViewController + Extansion.swift
//  Chat
//
//  Created by Олександр Швидкий on 30.04.2022.
//

import UIKit

extension UIViewController {
    func configure<T: SelfConfiguringCell, U: Hashable>(collectionView: UICollectionView,cellType: T.Type, with value: U, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else { fatalError("Unable to deqqueue \(cellType)") }
        cell.configure(with: value)
        return cell
    }
}
