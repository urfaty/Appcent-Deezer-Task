//
//  SongCell.swift
//  Appcent-Deezer-Task
//
//  Created by Tayfur Salih Şen on 9.05.2023.
//

import Foundation
import UIKit
import SDWebImage

protocol SongCellDelegate: AnyObject {
    func didTapHeart(on cell: SongCell)
}

class SongCell: UITableViewCell {
    
    static let identifier = "SongCell"
    private var song: Track?
    weak var delegate: SongCellDelegate?
    
    let heartButton: UIButton = {
        let button = UIButton()
        let heartImage = UIImage(systemName: "heart")
        button.setImage(heartImage, for: .normal)
        button.tintColor = .gray
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    private let songImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private let songTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let songDurationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(songImageView)
        contentView.addSubview(songTitleLabel)
        contentView.addSubview(songDurationLabel)
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        contentView.addSubview(heartButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        songImageView.frame = CGRect(x: 10, y: 10, width: 60, height: 60)
        songTitleLabel.frame = CGRect(x: 80, y: 10, width: contentView.frame.size.width - 90, height: 40)
        songDurationLabel.frame = CGRect(x: 80, y: 50, width: contentView.frame.size.width - 90, height: 20)
        heartButton.frame = CGRect(x: contentView.bounds.width - 50, y: (contentView.bounds.height - 30) / 2, width: 30, height: 30)
    }
    
    @objc private func heartButtonTapped() {
        toggleHeartIcon()
        delegate?.didTapHeart(on: self)
    }
    
    private func toggleHeartIcon() {
        guard let song = song else { return }
        if LocalDatabase.shared.isSongLiked(song) {
            LocalDatabase.shared.removeLikedSong(song)
            heartButton.tintColor = .gray
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            LocalDatabase.shared.saveLikedSong(song)
            heartButton.tintColor = .systemPink
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    
    func configure(with track: Track, albumCoverUrl: String) {
        self.song = track
        
        if let imageUrl = URL(string: albumCoverUrl) {
            songImageView.sd_setImage(with: imageUrl, placeholderImage: nil, options: [], completed: nil)
        }
        songTitleLabel.text = track.title
        songDurationLabel.text = durationString(from: track.duration)
        
        
        if LocalDatabase.shared.isSongLiked(track) {
            heartButton.tintColor = .systemPink
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            heartButton.tintColor = .gray
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    private func durationString(from duration: Int) -> String {
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
