//
//  File.swift
//  Appcent-Deezer-Task
//
//  Created by Tayfur Salih Şen on 9.05.2023.
//

import Foundation
import UIKit

class PlayerControlView: UIView {
    
    let timeRemainingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .right
        label.text = "0:30"
        return label
    }()
    
    let playPauseButton: UIButton = {
        let button = UIButton()
        let playImage = UIImage(systemName: "play.fill")
        let pauseImage = UIImage(systemName: "pause.fill")
        button.setImage(playImage, for: .normal)
        button.tintColor = .black
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 30
        slider.minimumTrackTintColor = UIColor.systemPink
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(slider)
        addSubview(timeRemainingLabel)
        addSubview(playPauseButton)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let controlHeight: CGFloat = 30
        let controlY: CGFloat = (bounds.height - controlHeight) / 2
        
        slider.frame = CGRect(x: 70, y: controlY, width: bounds.width - 130, height: controlHeight)
        timeRemainingLabel.frame = CGRect(x: bounds.width - 70, y: controlY, width: 50, height: controlHeight)
        playPauseButton.frame = CGRect(x: 15, y: controlY, width: 40, height: controlHeight)
    }
    
    func updatePlayPauseButton(isPlaying: Bool) {
        let playImage = UIImage(systemName: "play.fill")
        let pauseImage = UIImage(systemName: "pause.fill")
        let image = isPlaying ? pauseImage : playImage
        playPauseButton.setImage(image, for: .normal)
    }
}
