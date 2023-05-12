//
//  AlbumCell.swift
//  Appcent-Deezer-Task
//
//  Created by Tayfur Salih Şen on 9.05.2023.
//

import Foundation
import UIKit
import SDWebImage

class AlbumCell: UITableViewCell {
    
    static let identifier = "AlbumCell"
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(albumImageView)
        addSubview(titleLabel)
        addSubview(releaseDateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        albumImageView.frame = CGRect(x: 10, y: 10, width: 80, height: 80)
        titleLabel.frame = CGRect(x: albumImageView.frame.maxX + 10, y: 10, width: contentView.frame.width - albumImageView.frame.width - 30, height: 40)
        releaseDateLabel.frame = CGRect(x: albumImageView.frame.maxX + 10, y: titleLabel.frame.maxY, width: contentView.frame.width - albumImageView.frame.width - 30, height: 20)
    }
        
    func configure(with album: AlbumsOfSelectedArtist) {
        if let imageUrl = URL(string: album.cover) {
            albumImageView.sd_setImage(with: imageUrl, placeholderImage: nil, options: [], completed: nil)
        }
        titleLabel.text = album.title
        releaseDateLabel.text = album.release_date
    }

}
