//
//  ViewController.swift
//  ProfileLayout
//
//  Created by Anara Arman on 23.10.2026.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var initialsLabel: UILabel?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var subtitleLabel: UILabel?
    @IBOutlet weak var postsCountLabel: UILabel?
    @IBOutlet weak var followersCountLabel: UILabel?
    @IBOutlet weak var followingCountLabel: UILabel?
    @IBOutlet weak var aboutTextLabel: UILabel?

    let name = "Anara Armankyzy"

    override func viewDidLoad() {
        super.viewDidLoad()

        initialsLabel?.text = "AA"
        nameLabel?.text = name
        subtitleLabel?.text = "new ios developer"
        postsCountLabel?.text = "777"
        followersCountLabel?.text = "3.2K"
        followingCountLabel?.text = "248"
        aboutTextLabel?.text = "Slowly trying to be inlove in coding with xcode."
    }
}
