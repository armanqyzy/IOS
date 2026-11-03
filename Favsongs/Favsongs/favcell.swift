//
//  favcell.swift
//  Favsongs
//
//  Created by Anara Arman on 03.11.2026.
//

import UIKit

class FavoriteCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel?
    @IBOutlet weak var coverImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var artistLabel: UILabel?
    @IBOutlet weak var heartsStackView: UIStackView?

    func configure(with item: FavoriteItem, number: Int) {
        numberLabel?.text = "\(number)"
        titleLabel?.text = item.title
        artistLabel?.text = item.artist
        coverImageView?.image = UIImage(named: item.imageName)

        let hearts = heartsStackView?.arrangedSubviews ?? []
        for (index, view) in hearts.enumerated() {
            if let heart = view as? UIImageView {
                let symbolName = index < item.rating ? "heart.fill" : "heart"
                heart.image = UIImage(systemName: symbolName)
            }
        }
    }

}
