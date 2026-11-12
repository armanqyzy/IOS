//
//  FavoriteCell.swift
//  FavoritesNavigator
//
//  Created by Anara Arman on 12.11.2026.
//

import UIKit

class FavoriteCell: UITableViewCell {

    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    func configure(with item: FavoriteItem) {
        photoImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
    }
}
