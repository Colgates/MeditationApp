//
//  HomeViewControllerViewModel.swift
//  MeditationApp
//
//  Created by Evgenii Kolgin on 31.08.2021.
//

import Combine
import UIKit

enum Section {
    case main
}

final class HomeViewControllerViewModel {
    
    private var cancellables: Set<AnyCancellable> = []
    
    var dataSource: UITableViewDiffableDataSource<Section, Meditation>?
    
    func fetchData(isComplete: @escaping (Bool)->Void) {
        APICaller.shared.getMeditationDataUsingCombine()
            .receive(on: RunLoop.main)
            .sink { completion in
                print(completion)
                isComplete(true)
            } receiveValue: { [weak self] meditations in
                self?.updateSnapshot(with: meditations)
            }
            .store(in: &self.cancellables)
    }
    
    private func updateSnapshot(with items: [Meditation]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Meditation>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
