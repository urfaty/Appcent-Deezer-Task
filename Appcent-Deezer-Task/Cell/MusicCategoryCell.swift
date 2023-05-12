//
//  File.swift
//  Appcent-Deezer-Task
//
//  Created by Tayfur Salih Şen on 8.05.2023.
//

import UIKit
import SDWebImage

class MusicCategoryCell: UICollectionViewCell {
    
    static let identifier = "MusicCategoryCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.width)
        label.frame = CGRect(x: 0, y: imageView.frame.size.height - 20, width: contentView.frame.size.width, height: 20)
        label.backgroundColor = UIColor(white: 1.0, alpha: 0.7)
    }
    
    func configure(with model: MusicCategory) {
        label.text = model.name
        guard let url = URL(string: model.picture_medium) else {
            return
        }
        imageView.sd_setImage(with: url, placeholderImage: nil, options: [], completed: nil)
    }

}
