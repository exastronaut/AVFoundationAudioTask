//
//  ViewController.swift
//  AVFoundation_Audio
//
//  Created by Niki Pavlove on 18.02.2021.
//

import UIKit
import AVFoundation

final class ViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playButtonLabel: UIButton!

    private var player = AVAudioPlayer()
    private var counter = 0
    private let music = MusicService().getSong()

    // MARK: - Override functions

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMusicPalyer()
    }

    // MARK: - IBAction

    @IBAction func nextButton(_ sender: Any) {
        increaseCounter(&counter)
        setupMusicPalyer()
        player.play()
        
        if player.isPlaying {
            playButtonLabel.setImage(UIImage(systemName: Constants.pause), for: .normal)
        }
    }

    @IBAction func backButton(_ sender: Any) {
        decreaseCounter(&counter)
        setupMusicPalyer()
        player.play()

        if player.isPlaying {
            playButtonLabel.setImage(UIImage(systemName: Constants.pause), for: .normal)
        }
    }

    @IBAction func playButton(_ sender: Any) {

        if player.isPlaying {
            player.pause()
            playButtonLabel.setImage(UIImage(systemName: Constants.play), for: .normal)
        } else {
            player.play()
            playButtonLabel.setImage(UIImage(systemName: Constants.pause), for: .normal)
        }

    }
    
    @IBAction func stopButton(_ sender: Any) {
        if player.isPlaying {
            player.stop()
            player.currentTime = 0
            playButtonLabel.setImage(UIImage(systemName: Constants.play), for: .normal)
        }
    }
}

// MARK: - Private functions

private extension ViewController {

    func setupMusicPalyer() {
        guard let currentMusicURL = Bundle.main.url(forResource: music[counter], withExtension: Constants.extension)
        else { return }

        let currentMusicName = music[counter]

        nameLabel.text = currentMusicName

        do {
            player = try AVAudioPlayer(contentsOf: currentMusicURL)
            setupAudioSession()
        } catch {
            print(error.localizedDescription)
        }
    }

    func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(.playback)
        } catch {
            print(error.localizedDescription)
        }
    }

    func decreaseCounter(_ counter: inout Int) {
        if counter == 0 {
            counter = music.count - 1
        } else {
            counter -= 1
        }
    }

    func increaseCounter(_ counter: inout Int) {
        if counter == music.count - 1 {
            counter = 0
        } else {
            counter += 1
        }
    }

}

// MARK: - Private functions

private extension ViewController {

    enum Constants {
        static let `extension` = "mp3"
        static let play = "play.fill"
        static let pause = "pause.fill"
    }

}
