//
//  SoundsViewControllerViewModel.swift
//  MeditationApp
//
//  Created by Evgenii Kolgin on 07.09.2021.
//

import Combine
import UIKit

final class SoundsViewControllerViewModel {
 
    private var cancellables: Set<AnyCancellable> = []
    
    var dataSource: UITableViewDiffableDataSource<Section, Sound>?
    
    func fetchData(isComplete: @escaping (Bool)->Void) {
        APICaller.shared.getSoundsData()
            .receive(on: RunLoop.main)
            .sink { completion in
                print(completion)
                isComplete(true)
            } receiveValue: { [weak self] sounds in
                self?.updateSnapshot(with: sounds)
            }
            .store(in: &self.cancellables)
    }
    
    private func updateSnapshot(with items: [Sound]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Sound>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }

}
