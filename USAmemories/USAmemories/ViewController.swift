//
//  ViewController.swift
//  USAmemories
//
//  Created by Anara Arman on 16.10.2026.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var postcardView: UIView!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var polaroidView: UIView!
    @IBOutlet weak var myPhotoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!

    let places: [Place] = [
        Place(name: "San Francisco", state: "California",
              description: "Golden Gate bridge, the stunning place where Alcatraz is near...",
              photoName: "SanFrancisco", myPhotoName: "SanFranciscoMe",
              color: UIColor(red: 192/255, green: 57/255, blue: 43/255, alpha: 1)),   // Golden Gate orange-red
        Place(name: "Ocean City", state: "Maryland",
              description: "Beach with friends, great food and a lively atmosphere",
              photoName: "OceanCity", myPhotoName: "OceanCityMe",
              color: UIColor(red: 2/255, green: 119/255, blue: 189/255, alpha: 1)),   // ocean blue
        Place(name: "Washington, D.C.", state: "D.C.",
              description: "Capital of USA and its famous monument(while i was sick).",
              photoName: "Washington", myPhotoName: "WashingtonMe",
              color: UIColor(red: 31/255, green: 58/255, blue: 104/255, alpha: 1)),   // navy, like the flag
        Place(name: "New York City", state: "New York",
              description: "Times Square and energy of big city(of course with kazakhstan flag).",
              photoName: "NewYork", myPhotoName: "NewYorkMe",
              color: UIColor(red: 168/255, green: 122/255, blue: 0/255, alpha: 1)),   // yellow taxi
        Place(name: "Niagara Falls", state: "New York",
              description: "Majestic waterfalls and unbelievable view (at night there is a show with fireworks).",
              photoName: "NiagaraFalls", myPhotoName: "NiagaraFallsMe",
              color: UIColor(red: 0/255, green: 137/255, blue: 123/255, alpha: 1)),   // turquoise water
        Place(name: "Las Vegas", state: "Nevada",
              description: "Casinos all over the city)",
              photoName: "LasVegas", myPhotoName: "LasVegasMe",
              color: UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1)),   // neon purple
        Place(name: "Los Angeles", state: "California",
              description: "Hollywood, of course GTA vibes from childhood that come true.",
              photoName: "LosAngeles", myPhotoName: "LosAngelesMe",
              color: UIColor(red: 232/255, green: 86/255, blue: 42/255, alpha: 1)),   // sunset orange
        Place(name: "Grand Canyon", state: "Arizona",
              description: "A huuuge canyon with wow view, my friend accidentally dropped his phone hahahaha.",
              photoName: "GrandCanyon", myPhotoName: "GrandCanyonMe",
              color: UIColor(red: 160/255, green: 82/255, blue: 45/255, alpha: 1)),   // red rocks
        Place(name: "Rehoboth Beach", state: "Delaware",
              description: "Spending all your money in outlets(cuz tax free).",
              photoName: "RehobothBeach", myPhotoName: "RehobothBeachMe",
              color: UIColor(red: 216/255, green: 27/255, blue: 96/255, alpha: 1)),   // shopping pink
        Place(name: "Assateague Island", state: "Maryland",
              description: "Visited wild horses with my landlord Judy.",
              photoName: "Assateague", myPhotoName: "AssateagueMe",
              color: UIColor(red: 85/255, green: 139/255, blue: 47/255, alpha: 1))   // wild nature green
    ]

    // index of postcard on screen (-1 = the cover is shown)
    var currentIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Rounded corners and soft shadows
        postcardView.layer.cornerRadius = 20
        postcardView.layer.shadowColor = UIColor.black.cgColor
        postcardView.layer.shadowOpacity = 0.15
        postcardView.layer.shadowRadius = 12
        postcardView.layer.shadowOffset = CGSize(width: 0, height: 6)

        placeImageView.layer.cornerRadius = 12

        polaroidView.layer.shadowColor = UIColor.black.cgColor
        polaroidView.layer.shadowOpacity = 0.3
        polaroidView.layer.shadowRadius = 6
        polaroidView.layer.shadowOffset = CGSize(width: 0, height: 3)
      
        // Turn the palaroid a little, like it is glued to the postcard
        polaroidView.transform = CGAffineTransform(rotationAngle: 0.10)

        nextButton.layer.cornerRadius = 10
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        // pick a random place, but not the same one as now
        var newIndex = Int.random(in: 0..<places.count)
        while newIndex == currentIndex {
            newIndex = Int.random(in: 0..<places.count)
        }
        currentIndex = newIndex

        let place = places[newIndex]

       
        // update image, title and description together
        placeImageView.image = UIImage(named: place.photoName)
        myPhotoImageView.image = UIImage(named: place.myPhotoName)
        titleLabel.text = place.name
        descriptionLabel.text = place.description

        // colors of place
        titleLabel.textColor = place.color
        nextButton.backgroundColor = place.color
        numberLabel.text = "POSTCARD \(newIndex + 1) OF \(places.count)  ·  \(place.state.uppercased())"
    }
}
