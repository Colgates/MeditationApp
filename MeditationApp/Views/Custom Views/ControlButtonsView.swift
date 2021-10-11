//
//  ControlButtonsView.swift
//  MeditationApp
//
//  Created by Evgenii Kolgin on 01.09.2021.
//

import UIKit

protocol ControlButtonsViewDelegate: AnyObject {
    func shuffleButtonTapped()
    func backButtonTapped()
    func playButtonTapped()
    func forwardButtonTapped()
    func repeatButtonTapped()
}

class ControlButtonsView: UIView {
    
    weak var delegate: ControlButtonsViewDelegate?
    
    private let shuffleButton: SoftUIView = {
        let button = SoftUIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.addTarget(self, action: #selector(shuffleButtonTapped), for: .touchUpInside)
        button.cornerRadius = 20
        button.type = .toggleButton
        return button
    }()
    
    private let backButton: SoftUIView = {
        let button = SoftUIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.cornerRadius = 25
        return button
    }()
    
    private let playButton: SoftUIView = {
        let button = SoftUIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        button.cornerRadius = 50
        button.type = .toggleButton
        return button
    }()
    
    private let forwardButton: SoftUIView = {
        let button = SoftUIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        button.cornerRadius = 25
        return button
    }()
    
    private let repeatButton: SoftUIView = {
        let button = SoftUIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.addTarget(self, action: #selector(repeatButtonTapped), for: .touchUpInside)
        button.cornerRadius = 20
        button.backgroundColor = Colors.main
        button.type = .toggleButton
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(shuffleButton)
        addSubview(backButton)
        addSubview(playButton)
        addSubview(forwardButton)
        addSubview(repeatButton)
        
        setupControlButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let widthCenter = bounds.size.width / 2
        let heightCenter = bounds.size.height / 2
        let spacing: CGFloat = 10

        shuffleButton.center.y = heightCenter
        backButton.center.y = heightCenter
        playButton.center.y = heightCenter
        forwardButton.center.y = heightCenter
        repeatButton.center.y = heightCenter

        playButton.center.x = widthCenter
        backButton.center.x = playButton.left - spacing - (backButton.width / 2)
        forwardButton.center.x = playButton.right + spacing + (forwardButton.width / 2)
        repeatButton.center.x = forwardButton.right + spacing + (repeatButton.width / 2)
        shuffleButton.center.x = backButton.left - spacing - (shuffleButton.width / 2)
    }
    
    private func setupControlButtons() {
        setupSoftButton(button: shuffleButton, buttonImage: Images.shuffleButton, selectedButtonImage: Images.shuffleButton)
        setupSoftButton(button: backButton, buttonImage: Images.backButton, selectedButtonImage: Images.backButton)
        setupSoftButton(button: playButton, buttonImage: Images.playButton, selectedButtonImage: Images.pauseButton)
        setupSoftButton(button: forwardButton, buttonImage: Images.forwardButton, selectedButtonImage: Images.forwardButton)
        setupSoftButton(button: repeatButton, buttonImage: Images.repeatButton, selectedButtonImage: Images.repeatButton)
    }
    
    private func setupSoftButton(button: SoftUIView, buttonImage: UIImage, selectedButtonImage: UIImage) {
        let image = UIImageView(image: buttonImage)
        image.tintColor = Colors.tintColor
        
        let selectedImage = UIImageView(image: selectedButtonImage)
        selectedImage.tintColor = Colors.selectedTintColor
        
        image.translatesAutoresizingMaskIntoConstraints = false
        selectedImage.translatesAutoresizingMaskIntoConstraints = false
        
        button.setContentView(image, selectedContentView: selectedImage)
        image.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        selectedImage.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        selectedImage.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
    }
    
    @objc private func shuffleButtonTapped() {
        delegate?.shuffleButtonTapped()
    }
    
    @objc private func backButtonTapped() {
        delegate?.backButtonTapped()
    }
    
    @objc private func playButtonTapped() {
        delegate?.playButtonTapped()
    }
    
    @objc private func forwardButtonTapped() {
        delegate?.forwardButtonTapped()
    }
    
    @objc private func repeatButtonTapped() {
        delegate?.repeatButtonTapped()
    }
}
