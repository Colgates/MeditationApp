//
//  RoundedShadow.swift
//  MeditationApp
//
//  Created by Evgenii Kolgin on 04.09.2021.
//

import UIKit

class RoundedShadow: UIView {
    
    private let containerView = UIView()
    private let imageView = UIImageView()

    private let darkShadow = CALayer()
    private let lightShadow = CALayer()
    
    var lightShadowColor: UIColor = .white
    var darkShadowColor: UIColor = .black
    
    var image: UIImage? {
        didSet {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.frame = bounds
        imageView.frame = containerView.bounds
        let cornerRadius = containerView.frame.size.width / 2
        
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = true
        
        darkShadow.cornerRadius = cornerRadius
        darkShadow.shadowColor = darkShadowColor.cgColor
        darkShadow.shadowOffset = CGSize(width: 10, height: 10)
        darkShadow.shadowOpacity = 0.6
        darkShadow.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadius).cgPath
//        darkShadow.shadowRadius = 10
        containerView.layer.insertSublayer(darkShadow, at: 0)
        
        lightShadow.cornerRadius = cornerRadius
        lightShadow.shadowColor = lightShadowColor.cgColor
        lightShadow.shadowOffset = CGSize(width: -5, height: -5)
        lightShadow.shadowOpacity = 0.8
        lightShadow.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadius).cgPath
//        lightShadow.shadowRadius = 10
        containerView.layer.insertSublayer(lightShadow, above: darkShadow)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
}
