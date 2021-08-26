//
//  PhotoSearchViewModel.swift
//  PhotoSearchApp
//
//  Created by Evgenii Kolgin on 26.08.2021.
//

import Combine
import UIKit

enum SectionKind: Int, CaseIterable {
    case main
}

class PhotoSearchViewModel {
    
    var dataSource: UICollectionViewDiffableDataSource<SectionKind, Photo>?
    
    @Published var searchText = ""
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        $searchText
            .debounce(for: .seconds(1.0), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.searchPhotos(for: text)
            }
            .store(in: &subscriptions)
    }
    
    func searchPhotos(for query: String) {
        APIClient().searchPhotos(for: query)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] photos in
                self?.updateSnapshot(with: photos)
            }
            .store(in: &subscriptions)
    }
    
    private func updateSnapshot(with photos: [Photo]) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionKind, Photo>()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}
