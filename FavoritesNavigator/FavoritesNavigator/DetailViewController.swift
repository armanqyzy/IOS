//
//  DetailViewController.swift
//  FavoritesNavigator
//
//  Created by Anara Arman on 12.11.2026.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var ratingStackView: UIStackView!
    @IBOutlet private weak var descriptionLabel: UILabel!

    var item: FavoriteItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let item = item else {
            return
        }

        navigationItem.title = item.title
        photoImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        descriptionLabel.text = item.description
        showRating(item.rating)
    }

    // the stack view has 5 star image views: filled stars for the rating, empty stars for the rest
    private func showRating(_ rating: Int) {
        for (index, view) in ratingStackView.arrangedSubviews.enumerated() {
            guard let starImageView = view as? UIImageView else {
                continue
            }
            if index < rating {
                starImageView.image = UIImage(systemName: "star.fill")
            } else {
                starImageView.image = UIImage(systemName: "star")
            }
        }
    }
}
