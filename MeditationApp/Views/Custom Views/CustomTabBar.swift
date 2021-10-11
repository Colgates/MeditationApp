//
//  CustomTabBar.swift
//  MeditationApp
//
//  Created by Evgenii Kolgin on 07.09.2021.
//

import UIKit

protocol CustomTabBarDelegate: AnyObject {
    func homeButtonTapped()
    func soundsButtonTapped()
    func timerButtonTapped()
}

class CustomTabBar: UIView {
    
    weak var delegate: CustomTabBarDelegate?
    
    private let homeTab: UIButton = {
        let button = UIButton()
        let image = Images.homeButton.withConfiguration(UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
//        let image = UIImage(systemName: Images.homeButton, withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.tintColor = Colors.secondaryColor
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let soundsTab: UIButton = {
        let button = UIButton()
        let image = Images.soundsButton.withConfiguration(UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
//        let image = UIImage(systemName: Images.soundsButton, withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.tintColor = Colors.secondaryColor
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(soundsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let timerTab: UIButton = {
        let button = UIButton()
        let image = Images.timerButton.withConfiguration(UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
//        let image = UIImage(systemName: Images.timerButton, withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        button.tintColor = Colors.secondaryColor
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(timerButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [homeTab, soundsTab, timerTab])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(stackView)

        stackView.frame = bounds
    }
    
    @objc private func homeButtonTapped() {
        delegate?.homeButtonTapped()
    }
    
    @objc private func soundsButtonTapped() {
        delegate?.soundsButtonTapped()
    }
    
    @objc private func timerButtonTapped() {
        delegate?.timerButtonTapped()
    }
}
