//
//  HomeCollectionTableViewCell.swift
//  MovieTime
//
//  Created by Evgenii Kolgin on 22.07.2021.
//

import UIKit

protocol HomeCollectionTableViewCellDelegate: AnyObject {
    func didSelectItem(with model: Item)
}

class HomeCollectionTableViewCell: UITableViewCell {

    public weak var delegate: HomeCollectionTableViewCellDelegate?
    
    static let identifier = "HomeCollectionTableViewCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.tintColor
        label.font = .systemFont(ofSize: 22)
        return label
    }()
    
    private let containerView: UIView = {
        let container = UIView()
        container.backgroundColor = Colors.main
        return container
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.backgroundColor = Colors.main
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, Item>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(collectionView)
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        
        containerView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 50)
        titleLabel.frame = CGRect(x: 20, y: 0, width: frame.size.width - 40, height: 50)
        collectionView.frame = CGRect(x: 0, y: 50, width: frame.size.width, height: frame.size.height - 50)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: model, titleIsHidden: false)
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.layer.bounds, cornerRadius: 10).cgPath
            return cell
        })
    }
    
    private func updateSnapshot(with items: [Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func configure(with model: Meditation) {
        configureDataSource()
        updateSnapshot(with: model.items)
        titleLabel.text = model.title
    }
}
// MARK: - UICollectionViewDelegate
extension HomeCollectionTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        delegate?.didSelectItem(with: item)
    }
}

// MARK: - CollectionView Item Size
extension HomeCollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let size = dataSource?.snapshot().itemIdentifiers.count else { return CGSize(width: 50, height: 50)}
        if size <= 2 {
        return CGSize(width: collectionView.frame.size.width - 40, height: collectionView.frame.size.width * 0.51)
        } else {
            return CGSize(width: collectionView.frame.size.width * 0.51, height: collectionView.frame.size.width * 0.51)
        }
    }
}
