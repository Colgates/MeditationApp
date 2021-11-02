//
//  HomeViewController.swift
//  MeditationApp
//
//  Created by Evgenii Kolgin on 30.08.2021.
//

import Lottie
import UIKit

class HomeViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(HomeCollectionTableViewCell.self, forCellReuseIdentifier: HomeCollectionTableViewCell.identifier)
        tableView.backgroundColor = Colors.main
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        tableView.isHidden = true
        return tableView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.isHidden = false
        return activityIndicator
    }()
    
    private let viewModel = HomeViewControllerViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.main
        view.addSubview(activityIndicator)
        view.addSubview(tableView)
        
        tableView.delegate = self
        
        activityIndicator.startAnimating()
        
        viewModel.fetchData { done in
            if done {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.tableView.isHidden = false
            }
        }
        
        configureDatasource()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.center = view.center
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func configureDatasource() {
        viewModel.dataSource = UITableViewDiffableDataSource<Section, Meditation>(tableView: tableView, cellProvider: { tableView, indexPath, model in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeCollectionTableViewCell.identifier, for: indexPath) as? HomeCollectionTableViewCell else { return UITableViewCell() }
//            let cell = HomeCollectionTableViewCell()
            cell.configure(with: model)
            cell.delegate = self
            return cell
        })
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.width * 0.7
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 90))
        footerView.backgroundColor = Colors.main
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 90
    }
}

// MARK: - HomeCollectionTableViewCellDelegate
//extension HomeViewController: HomeCollectionTableViewCellDelegate {
//    func didSelectItem(with model: Item) {
//        let vc = MediaPlayerViewController()
//        vc.configure(with: model)
//        vc.modalTransitionStyle = .coverVertical
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true, completion: nil)
//    }
//}

extension HomeViewController: HomeCollectionTableViewCellDelegate {
    func didSelectItem(with model: Item) {
        let vc = MediaPlayerViewController()
        vc.configure(with: model)
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
