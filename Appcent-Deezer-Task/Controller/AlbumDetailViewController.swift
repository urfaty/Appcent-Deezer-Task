//
//  File.swift
//  Appcent-Deezer-Task
//
//  Created by Tayfur Salih Şen on 9.05.2023.
//

import UIKit
import SDWebImage
import AVFoundation

class AlbumDetailViewController: UIViewController {
    
    var albumId: Int?
    var albumDetail: AlbumDetail?
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
        navigationController?.navigationBar.tintColor = .systemPink
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if let albumId = albumId {
            AlbumDetailApiRequest.fetchAlbumDetails(albumId: albumId) { result in
                switch result {
                case .success(let albumDetail):
                    self.albumDetail = albumDetail
                    DispatchQueue.main.async {
                        self.title = albumDetail.title
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("Error decoding data: \(error.localizedDescription)")
                }
            }
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
        playerControlView.slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        playerControlView.playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        view.addSubview(playerControlView)
        configurePlayerControlView()
    }
    
    deinit {
        removeTimeObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let safeAreaInsetsBottom = view.safeAreaInsets.bottom
        let playerControlViewHeight: CGFloat = 50
        
        tableView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - safeAreaInsetsBottom)
        playerControlView.frame = CGRect(x: 0, y: view.bounds.height - playerControlViewHeight - safeAreaInsetsBottom, width: view.bounds.width, height: playerControlViewHeight)
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

extension AlbumDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumDetail?.tracks.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongCell.identifier, for: indexPath) as! SongCell
        if let track = albumDetail?.tracks.data[indexPath.row], let albumCoverUrl = albumDetail?.cover_medium {
            cell.configure(with: track, albumCoverUrl: albumCoverUrl)
        }
        return cell
    }
}

extension AlbumDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let previewUrl = albumDetail?.tracks.data[indexPath.row].preview {
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
}
