//
//  MusicViewController.swift
//  Demo0819
//
//  Created by 林思甯 on 2021/8/19.
//

import UIKit
import AVFoundation

class MusicViewController: UIViewController {
    
    var songs = [SongType]()
    
    var player = AVPlayer()
    var playerItem: AVPlayerItem!
    var timeObserverToken: Any?

    var songIndex: Int!
    
    var isPlaying = true
    
    var timer = Timer()
    
    var currentTimeInSec: Float!
    var totalTimeInSec: Float!
    var remainingTimeInSec: Float!
    
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var songProgress: UIProgressView!
    @IBOutlet var timeLabel: [UILabel]!
    @IBOutlet var playButton: [UIButton]!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        DataController.shared.fetchMusic() { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let songs):
                    self.updateUI(with: songs)
                    self.playMusic()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        // AV Player
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { [weak self] (notification) in

            if self?.songIndex == (self?.songs.count)! - 1 {
                self?.songIndex = 0
            } else {
                self?.songIndex += 1
            }
        
            self?.playMusic()

        }
    }
    func updateUI(with songItem: [SongType]) {
            self.songs = songItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        removePeriodicTimeObserver()
    }
    
    @IBAction func volumeButtonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            player.isMuted = true
        } else {
            player.isMuted = false
        }
    }
    
    @IBAction func voiceSliderChange(_ sender: UISlider) {
        let silderValue = sender.value
        player.volume = silderValue
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            if songIndex == 0 {
                songIndex = songs.count - 1
            } else {
                songIndex -= 1
            }
            
            playButton[1].setImage(UIImage(systemName: "pause.fill"), for: .normal)
            playMusic()
            
        case 1:
            isPlaying ? player.pause() : player.play()
            sender.setImage(UIImage(systemName: isPlaying ? "play.fill" :  "pause.fill"), for: .normal)
            isPlaying = !isPlaying

        case 2:
            if songIndex == songs.count - 1 {
                songIndex = 0
            } else {
                songIndex += 1
            }
            
            playButton[1].setImage(UIImage(systemName: "pause.fill"), for: .normal)
            playMusic()
        default:
            print("error")
        }
    }
    
    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    func updateProgressUI() {
        
        if currentTimeInSec == totalTimeInSec {
            removePeriodicTimeObserver()
        } else {
            remainingTimeInSec = totalTimeInSec - currentTimeInSec
            timeLabel[0].text = timeConverter(currentTimeInSec)
            timeLabel[1].text = "-\(timeConverter(remainingTimeInSec))"
            songProgress.progress = currentTimeInSec / totalTimeInSec
        }
        
    }
    
    func timeConverter(_ timeInSecond: Float) -> String {
        let minute = Int(timeInSecond) / 60
        let second = Int(timeInSecond) % 60
        
        return second < 10 ? "\(minute):0\(second)" : "\(minute):\(second)"

    }
    
    func updateInfo() {
        let currentSong = songs[songIndex]
        songNameLabel.text = currentSong.trackName
        artistLabel.text = currentSong.artistName
    }
    
    func playMusic() {
        
        removePeriodicTimeObserver()
        
        // Play music
        let songURL = songs[songIndex].previewUrl
        playerItem = AVPlayerItem(url: songURL!)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
        // Update song info
        DispatchQueue.main.async {
            self.updateInfo()
        }
        
        // Update song image
        DataController.shared.fetchImage(urlStr: songs[songIndex].artworkUrl100) { (image) in
            DispatchQueue.main.async {
                self.songImage.image = image
            }
        }
        
        // Time observer
        addPeriodicTimeObserver()
    }
    
    func addPeriodicTimeObserver() {
        // Notify every half second
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)

        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
            let duration = self?.playerItem.asset.duration
            let second = CMTimeGetSeconds(duration!)
            self!.totalTimeInSec = Float(second)
            
            let songCurrentTime = self?.player.currentTime().seconds
            self!.currentTimeInSec = Float(songCurrentTime!)
            
            self!.updateProgressUI()
            
        }
    }
    
}
