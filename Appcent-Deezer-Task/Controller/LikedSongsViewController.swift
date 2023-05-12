//
//  SecondViewController.swift
//  Appcent-Deezer-Task
//
//  Created by Tayfur Salih Şen on 8.05.2023.
//

import UIKit
import AVFoundation

class LikedSongsViewController: UIViewController {
    
    private var likedSongs: [Track] = []
    var player: AVPlayer?
    private var timeObserverToken: Any?
    private let playerControlView = PlayerControlView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SongCell.self, forCellReuseIdentifier: SongCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Beğenilen Şarkılar"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemPink]

        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
        likedSongs = LocalDatabase.shared.getLikedSongs()
        tableView.reloadData()
        
        playerControlView.slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        playerControlView.playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        view.addSubview(playerControlView)
        configurePlayerControlView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 0
        tableView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 50 - tabBarHeight)
        playerControlView.frame = CGRect(x: 0, y: view.bounds.height - 50 - tabBarHeight, width: view.bounds.width, height: 50)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        player?.pause()
        player = nil
        removeTimeObserver()
        
        playerControlView.updatePlayPauseButton(isPlaying: false)
        playerControlView.slider.value = 0
        playerControlView.slider.isEnabled = false
        playerControlView.timeRemainingLabel.text = "0:00"
    }

    private func refreshData() {
        likedSongs = LocalDatabase.shared.getLikedSongs()
        likedSongs.reverse()
        tableView.reloadData()
    }
    
    @objc private func sliderValueChanged() {
        let sliderValue = playerControlView.slider.value
        let time = CMTime(seconds: Double(sliderValue), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player?.seek(to: time)
    }
    
    
    @objc private func playPauseButtonTapped() {
        guard let player = player else { return }
        
        if player.timeControlStatus == .paused {
            player.play()
            playerControlView.updatePlayPauseButton(isPlaying: true)
        } else {
            player.pause()
            playerControlView.updatePlayPauseButton(isPlaying: false)
        }
    }
    
    func configurePlayerControlView() {
        if let player = player, player.timeControlStatus != .paused {
            playerControlView.updatePlayPauseButton(isPlaying: true)
            playerControlView.slider.isEnabled = true
        } else {
            playerControlView.updatePlayPauseButton(isPlaying: false)
            playerControlView.slider.isEnabled = false
        }
    }
    
    private func addTimeObserver() {
        let interval = CMTimeMakeWithSeconds(1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.updateSliderAndTimeLabel()
        }
    }
    
    private func removeTimeObserver() {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    
    private func updateSliderAndTimeLabel() {
        guard let currentTime = player?.currentTime().seconds else { return }
        playerControlView.slider.value = Float(currentTime)
        
        let remainingTime = 30 - Int(currentTime)
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        playerControlView.timeRemainingLabel.text = String(format: "%d:%02d", minutes, seconds)
    }
    
}

extension LikedSongsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongCell.identifier, for: indexPath) as! SongCell
        let track = likedSongs[indexPath.row]
        let albumCoverUrl = "https://e-cdns-images.dzcdn.net/images/cover/\(track.md5_image)/250x250-000000-80-0-0.jpg"
        cell.configure(with: track, albumCoverUrl: albumCoverUrl)
        cell.delegate = self
        return cell
    }
}

extension LikedSongsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let previewUrl = likedSongs[indexPath.row].preview
        player?.pause()
        player = nil
        removeTimeObserver()
        
        if let url = URL(string: previewUrl) {
            player = AVPlayer(url: url)
            addTimeObserver()
            player?.play()
            configurePlayerControlView()
        }
    }
}

extension LikedSongsViewController: SongCellDelegate {
    func didTapHeart(on cell: SongCell) {
        refreshData()
    }
}


