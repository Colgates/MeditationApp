//
//  CategoryCollectionViewCell.swift
//  MovieTime
//
//  Created by Evgenii Kolgin on 20.07.2021.
//

import SDWebImage
import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CustomCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let containerView: UIView = {
        let container = UIView()
        container.backgroundColor = .black.withAlphaComponent(0.5)
        return container
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.addSubview(imageView)
        imageView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        
        imageView.frame = contentView.bounds
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            containerView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configure(with item: Item, titleIsHidden: Bool) {
        titleLabel.text = item.title
        containerView.isHidden = titleIsHidden
        imageView.sd_setImage(with: URL(string: item.imageURL), completed: nil)
    }
}
