//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Anara Arman on 29.10.2026.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!

    let tracks = TrackLibrary.tracks

    // State of the screen: which track and is it playing
    var currentIndex = 0
    var isPlaying = false

    // Stored here so the player lives as long as the screen
    var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTrack()
        updateScreen()
    }

    // Creates a player for the current track
    func loadTrack() {
        let track = tracks[currentIndex]

        guard let url = Bundle.main.url(forResource: track.fileName, withExtension: "mp3") else {
            print("File not found: \(track.fileName).mp3")
            player = nil
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.prepareToPlay()
        } catch {
            print("Could not open file \(track.fileName).mp3: \(error)")
            player = nil
        }
    }

    // Shows the current track and the right play/pause icon
    func updateScreen() {
        let track = tracks[currentIndex]
        coverImageView.image = UIImage(named: track.coverImageName)
        titleLabel.text = track.title
        artistLabel.text = track.artist

        if isPlaying {
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }

    // Stops the old track, loads the new one, keeps the play state
    func changeTrack() {
        player?.stop()
        loadTrack()
        if isPlaying {
            player?.play()
        }
        updateScreen()
    }

    func goToNextTrack() {
        currentIndex += 1
        if currentIndex == tracks.count {
            currentIndex = 0
        }
        changeTrack()
    }

    func goToPreviousTrack() {
        currentIndex -= 1
        if currentIndex < 0 {
            currentIndex = tracks.count - 1
        }
        changeTrack()
    }

    @IBAction func playPauseTapped(_ sender: UIButton) {
        if isPlaying {
            player?.pause()
            isPlaying = false
        } else {
            player?.play()
            isPlaying = true
        }
        updateScreen()
    }

    @IBAction func nextTapped(_ sender: UIButton) {
        goToNextTrack()
    }

    @IBAction func previousTapped(_ sender: UIButton) {
        goToPreviousTrack()
    }

    // Called by AVAudioPlayer when a track ends
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        goToNextTrack()
    }
}
