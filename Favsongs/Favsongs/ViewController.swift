//
//  ViewController.swift
//  Favsongs
//
//  Created by Anara Arman on 03.11.2026.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView?

    let items: [FavoriteItem] = [
        FavoriteItem(title: "Фея", artist: "Miyagi & Эндшпиль", imageName: "1", rating: 3),
        FavoriteItem(title: "Волна", artist: "DJ Smash", imageName: "2", rating: 4),
        FavoriteItem(title: "Beware", artist: "Big Sean feat. Lil Wayne & Jhené Aiko", imageName: "3", rating: 5),
        FavoriteItem(title: "Motivation", artist: "Kelly Rowland feat. Lil Wayne", imageName: "4", rating: 5),
        FavoriteItem(title: "Creep", artist: "Radiohead", imageName: "5", rating: 5),
        FavoriteItem(title: "Don't Stop the Music", artist: "Rihanna", imageName: "6", rating: 3),
        FavoriteItem(title: "Maneater", artist: "Nelly Furtado", imageName: "7", rating: 2),
        FavoriteItem(title: "Only Girl (In the World)", artist: "Rihanna", imageName: "8", rating: 2),
        FavoriteItem(title: "S&M", artist: "Rihanna", imageName: "9", rating: 3),
        FavoriteItem(title: "Я твой номер один", artist: "Дима Билан", imageName: "10", rating: 3),
        FavoriteItem(title: "Ain't In LA", artist: "Adéla", imageName: "11", rating: 1),
        FavoriteItem(title: "Не могу", artist: "Егор Крид", imageName: "12", rating: 3),
        FavoriteItem(title: "Thin Ice", artist: "Megan Thee Stallion", imageName: "13", rating: 2),
        FavoriteItem(title: "Pink Blush (Remix)", artist: "Dolly Babe feat. Megan Thee Stallion", imageName: "14", rating: 1),
        FavoriteItem(title: "Outside", artist: "Coi Leray feat. Eladio Carrión", imageName: "15", rating: 5),
        FavoriteItem(title: "Not Yours", artist: "Lady Binladen", imageName: "16", rating: 1),
        FavoriteItem(title: "Deli", artist: "Ice Spice", imageName: "17", rating: 2),
        FavoriteItem(title: "Beauty and a Beat", artist: "Justin Bieber feat. Nicki Minaj", imageName: "18", rating: 3),
        FavoriteItem(title: "Stargirl Interlude", artist: "The Weeknd feat. Lana Del Rey", imageName: "19", rating: 2),
        FavoriteItem(title: "I Wanna Be Yours", artist: "Arctic Monkeys", imageName: "20", rating: 5)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.dataSource = self
        tableView?.delegate = self
    }


}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath)
        if let favoriteCell = cell as? FavoriteCell {
            favoriteCell.configure(with: items[indexPath.row], number: indexPath.row + 1)
        }
        return cell
    }

}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
